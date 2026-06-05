import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';
import 'package:graduation_project/features/favourite/domain/repository/favourite_repo.dart';

class RemoveFavouriteUseCase {
  final FavouriteRepo favouriteRepo;
  RemoveFavouriteUseCase(this.favouriteRepo);

  Future<Either<Failure, void>> call(String productId) async {
    return await favouriteRepo.removeFavourite(productId);
  }
}
