import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';
import 'package:graduation_project/features/favourite/domain/repository/favourite_repo.dart';

import '../entity/favourite_entity.dart';

class GetFavouritesUseCase {
  final FavouriteRepo favouriteRepo;
  GetFavouritesUseCase(this.favouriteRepo);

  Future<Either<Failure, List<FavouriteEntity>>> call() async {
    return await favouriteRepo.getFavourites();
  }
}
