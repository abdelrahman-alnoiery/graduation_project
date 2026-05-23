import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_favourite_usecase.dart';
import '../../domain/usecases/get_favourites_usecase.dart';
import '../../domain/usecases/remove_favourite_usecase.dart';
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
    emit(const FavouriteLoadingState());
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
    await addFavouriteUseCase(event.item as String);
    add(const GetFavouritesEvent());
  }

  Future<void> _onRemoveFavourite(
    RemoveFavouriteEvent event,
    Emitter<FavouriteState> emit,
  ) async {
    await removeFavouriteUseCase(event.productId);
    add(const GetFavouritesEvent());
  }
}
