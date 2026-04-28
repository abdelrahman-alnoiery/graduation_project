import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/cart/domain/repository/cart_repo.dart';

import '../../../../core/exceptions/failuers.dart';

class AddCartItemUseCase {
  final CartRepo cartRepo;

  AddCartItemUseCase(this.cartRepo);

  Future<Either<Failure, void>> call({
    required String productId,
    required String productName,
    required String productImage,
    required double price,
    required int quantity,
  }) async {
    return await cartRepo.addCartItem(
      productId: productId,
      productName: productName,
      productImage: productImage,
      price: price,
      quantity: quantity,
    );
  }
}
