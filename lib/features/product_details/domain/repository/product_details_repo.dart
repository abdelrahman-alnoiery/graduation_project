import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/product_details_entity.dart';

abstract class ProductDetailsRepo {
  Future<Either<Failure, ProductDetailsEntity>> getProductDetails(
    String productId,
  );
}
