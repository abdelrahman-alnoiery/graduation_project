import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/cart/domain/repository/cart_repo.dart';

import '../../../../core/exceptions/failuers.dart';

class RemoveCartItemUseCase {
  final CartRepo cartRepo;

  RemoveCartItemUseCase(this.cartRepo);

  Future<Either<Failure, void>> call(String productId) async {
    return await cartRepo.removeCartItem(productId);
  }
}
