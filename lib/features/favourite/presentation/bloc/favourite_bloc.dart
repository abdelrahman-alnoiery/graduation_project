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

  // ── Get Favourites ────────────────────────────────
  Future<void> _onGetFavourites(
    GetFavouritesEvent event,
    Emitter<FavouriteState> emit,
  ) async {
    emit(const FavouriteLoadingState());
    final result = await getFavouritesUseCase();
    result.fold((failure) => emit(FavouriteErrorState(failure)), (favourites) {
      if (favourites.isEmpty) {
        emit(const FavouritesEmptyState());
      } else {
        emit(GetFavouritesSuccessState(favourites));
      }
    });
  }

  // ── Add Favourite ─────────────────────────────────
  Future<void> _onAddFavourite(
    AddFavouriteEvent event,
    Emitter<FavouriteState> emit,
  ) async {
    final result = await addFavouriteUseCase(event.productId);
    result.fold((failure) => emit(FavouriteErrorState(failure)), (_) {
      emit(const AddFavouriteSuccessState());
      add(const GetFavouritesEvent());
    });
  }

  // ── Remove Favourite ──────────────────────────────
  Future<void> _onRemoveFavourite(
    RemoveFavouriteEvent event,
    Emitter<FavouriteState> emit,
  ) async {
    final result = await removeFavouriteUseCase(event.productId);
    result.fold((failure) => emit(FavouriteErrorState(failure)), (_) {
      emit(const RemoveFavouriteSuccessState());
      add(const GetFavouritesEvent());
    });
  }
}
