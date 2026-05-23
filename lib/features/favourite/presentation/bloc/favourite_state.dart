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

class FavouriteSuccessState extends FavouriteState {
  final List<FavouriteEntity> favourites;
  const FavouriteSuccessState(this.favourites);
}

class FavouriteEmptyState extends FavouriteState {
  const FavouriteEmptyState();
}

class FavouriteErrorState extends FavouriteState {
  final String message;
  const FavouriteErrorState(this.message);
}
