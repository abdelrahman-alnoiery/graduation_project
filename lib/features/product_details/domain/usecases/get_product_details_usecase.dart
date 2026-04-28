import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/product_details/domain/repository/product_details_repo.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/product_details_entity.dart';

class GetProductDetailsUseCase {
  final ProductDetailsRepo productDetailsRepo;
  GetProductDetailsUseCase(this.productDetailsRepo);

  Future<Either<Failure, ProductDetailsEntity>> call(String productId) async {
    return await productDetailsRepo.getProductDetails(productId);
  }
}
