import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';
import 'package:graduation_project/features/favourite/domain/repository/favourite_repo.dart';

import '../entity/favourite_entity.dart';

class AddFavouriteUseCase {
  final FavouriteRepo favouriteRepo;
  AddFavouriteUseCase(this.favouriteRepo);

  Future<Either<Failure, void>> call(FavouriteEntity item) async {
    return await favouriteRepo.addFavourite(item);
  }
}
