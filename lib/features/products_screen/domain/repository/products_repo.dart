import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failuers.dart';
import '../../../home/domain/entity/product_entity.dart';

abstract class ProductsRepo {
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    String categoryId,
  );
  Future<Either<Failure, List<ProductEntity>>> getAllProducts();
}
