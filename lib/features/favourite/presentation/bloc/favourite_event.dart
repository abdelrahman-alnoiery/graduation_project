import '../../domain/entity/favourite_entity.dart';

abstract class FavouriteEvent {
  const FavouriteEvent();
}

class GetFavouritesEvent extends FavouriteEvent {
  const GetFavouritesEvent();
}

class AddFavouriteEvent extends FavouriteEvent {
  final FavouriteEntity item;
  const AddFavouriteEvent(this.item);
}

class RemoveFavouriteEvent extends FavouriteEvent {
  final String productId;
  const RemoveFavouriteEvent(this.productId);
}
