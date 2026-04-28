import '../../../../core/exceptions/failuers.dart';
import '../../domain/entity/favourite_entity.dart';

abstract class FavouriteState {
  const FavouriteState();
}

class FavouriteInitialState extends FavouriteState {
  const FavouriteInitialState();
}

class FavouriteLoadingState extends FavouriteState {
  const FavouriteLoadingState();
}

class GetFavouritesSuccessState extends FavouriteState {
  final List<FavouriteEntity> favourites;
  const GetFavouritesSuccessState(this.favourites);
}

class FavouritesEmptyState extends FavouriteState {
  const FavouritesEmptyState();
}

class AddFavouriteSuccessState extends FavouriteState {
  const AddFavouriteSuccessState();
}

class RemoveFavouriteSuccessState extends FavouriteState {
  const RemoveFavouriteSuccessState();
}

class FavouriteErrorState extends FavouriteState {
  final Failure failure;
  const FavouriteErrorState(this.failure);
}
