import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/brand_entity.dart';
import '../entity/product_entity.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, List<ProductEntity>>> getBestPriceProducts();
  Future<Either<Failure, List<BrandEntity>>> getBrands();
  Future<Either<Failure, List<ProductEntity>>> getTrends();
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query);
}
