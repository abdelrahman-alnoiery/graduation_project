import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/favourite_entity.dart';

abstract class FavouriteRepo {
  Future<Either<Failure, List<FavouriteEntity>>> getFavourites();
  Future<Either<Failure, void>> addFavourite(String productId);
  Future<Either<Failure, void>> removeFavourite(String productId);
}
