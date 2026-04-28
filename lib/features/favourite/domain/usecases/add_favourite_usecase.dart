import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/favourite/domain/repository/favourite_repo.dart';

import '../../../../core/exceptions/failuers.dart';

class AddFavouriteUseCase {
  final FavouriteRepo favouriteRepo;
  AddFavouriteUseCase(this.favouriteRepo);

  Future<Either<Failure, void>> call(String productId) async {
    return await favouriteRepo.addFavourite(productId);
  }
}
