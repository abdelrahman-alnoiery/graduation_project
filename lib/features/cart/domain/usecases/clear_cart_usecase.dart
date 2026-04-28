import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/cart/domain/repository/cart_repo.dart';

import '../../../../core/exceptions/failuers.dart';

class ClearCartUseCase {
  final CartRepo cartRepo;

  ClearCartUseCase(this.cartRepo);

  Future<Either<Failure, void>> call() async {
    return await cartRepo.clearCart();
  }
}
