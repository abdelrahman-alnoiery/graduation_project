import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/cart/domain/repository/cart_repo.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/cart_item_entity.dart';

class GetCartItemsUseCase {
  final CartRepo cartRepo;

  GetCartItemsUseCase(this.cartRepo);

  Future<Either<Failure, List<CartItemEntity>>> call() async {
    return await cartRepo.getCartItems();
  }
}
