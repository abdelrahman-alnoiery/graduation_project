import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';
import 'package:graduation_project/features/products_screen/domain/repository/products_repo.dart';

import '../../../home/domain/entity/product_entity.dart';

class GetProductsByCategoryUseCase {
  final ProductsRepo productsRepo;
  GetProductsByCategoryUseCase(this.productsRepo);

  Future<Either<Failure, List<ProductEntity>>> call(String categoryId) async {
    return await productsRepo.getProductsByCategory(categoryId);
  }
}
