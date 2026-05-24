import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';
import 'package:graduation_project/features/cart/domain/repository/cart_repo.dart';

class UpdateCartItemUseCase {
  final CartRepo cartRepo;
  UpdateCartItemUseCase(this.cartRepo);

  Future<Either<Failure, void>> call({
    required String productId,
    required int quantity,
  }) async {
    return await cartRepo.updateCartItem(
      // ✅ updateCartItem مش updateCartItemQuantity
      productId: productId,
      quantity: quantity,
    );
  }
}
