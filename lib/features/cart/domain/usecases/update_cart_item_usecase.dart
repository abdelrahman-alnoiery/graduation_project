import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/cart/domain/repository/cart_repo.dart';

import '../../../../core/exceptions/failuers.dart';

class UpdateCartItemUseCase {
  final CartRepo cartRepo;

  UpdateCartItemUseCase(this.cartRepo);

  Future<Either<Failure, void>> call({
    required String productId,
    required int quantity,
  }) async {
    return await cartRepo.updateCartItemQuantity(
      productId: productId,
      quantity: quantity,
    );
  }
}
