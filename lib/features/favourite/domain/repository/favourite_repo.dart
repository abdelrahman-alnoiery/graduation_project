import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';

import '../entity/favourite_entity.dart';

abstract class FavouriteRepo {
  Future<Either<Failure, List<FavouriteEntity>>> getFavourites();
  Future<Either<Failure, void>> addFavourite(FavouriteEntity item);
  Future<Either<Failure, void>> removeFavourite(String productId);
}
