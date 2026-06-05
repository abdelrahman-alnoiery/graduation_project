import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/favourite/domain/usecases/add_favourite_usecase.dart';
import 'package:graduation_project/features/favourite/domain/usecases/get_favourites_usecase.dart';
import 'package:graduation_project/features/favourite/domain/usecases/remove_favourite_usecase.dart';

import '../../domain/entity/favourite_entity.dart';
import 'favourite_event.dart';
import 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  final GetFavouritesUseCase getFavouritesUseCase;
  final AddFavouriteUseCase addFavouriteUseCase;
  final RemoveFavouriteUseCase removeFavouriteUseCase;

  FavouriteBloc({
    required this.getFavouritesUseCase,
    required this.addFavouriteUseCase,
    required this.removeFavouriteUseCase,
  }) : super(const FavouriteInitialState()) {
    on<GetFavouritesEvent>(_onGetFavourites);
    on<AddFavouriteEvent>(_onAddFavourite);
    on<RemoveFavouriteEvent>(_onRemoveFavourite);
  }

  Future<void> _onGetFavourites(
    GetFavouritesEvent event,
    Emitter<FavouriteState> emit,
  ) async {
    final result = await getFavouritesUseCase();
    result.fold(
      (failure) => emit(FavouriteErrorState(failure.message)),
      (items) => items.isEmpty
          ? emit(const FavouriteEmptyState())
          : emit(FavouriteSuccessState(items)),
    );
  }

  Future<void> _onAddFavourite(
    AddFavouriteEvent event,
    Emitter<FavouriteState> emit,
  ) async {
    // ✅ أضف optimistically أول
    final currentItems = state is FavouriteSuccessState
        ? List<FavouriteEntity>.from(
            (state as FavouriteSuccessState).favourites,
          )
        : <FavouriteEntity>[];
    currentItems.add(event.item);
    emit(FavouriteSuccessState(currentItems));

    // ✅ احفظ في الـ Hive
    await addFavouriteUseCase(event.item);

    // ✅ reload من الـ Hive
    add(const GetFavouritesEvent());
  }

  Future<void> _onRemoveFavourite(
    RemoveFavouriteEvent event,
    Emitter<FavouriteState> emit,
  ) async {
    // ✅ اشيل optimistically أول
    if (state is FavouriteSuccessState) {
      final currentItems = List<FavouriteEntity>.from(
        (state as FavouriteSuccessState).favourites,
      )..removeWhere((f) => f.id == event.productId);
      currentItems.isEmpty
          ? emit(const FavouriteEmptyState())
          : emit(FavouriteSuccessState(currentItems));
    }

    // ✅ احذف من الـ Hive
    await removeFavouriteUseCase(event.productId);

    // ✅ reload
    add(const GetFavouritesEvent());
  }
}
