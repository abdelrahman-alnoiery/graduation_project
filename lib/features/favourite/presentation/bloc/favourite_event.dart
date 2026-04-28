abstract class FavouriteEvent {
  const FavouriteEvent();
}

class GetFavouritesEvent extends FavouriteEvent {
  const GetFavouritesEvent();
}

class AddFavouriteEvent extends FavouriteEvent {
  final String productId;
  const AddFavouriteEvent(this.productId);
}

class RemoveFavouriteEvent extends FavouriteEvent {
  final String productId;
  const RemoveFavouriteEvent(this.productId);
}
