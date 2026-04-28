import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/category_entity.dart';

abstract class CategoriesRepo {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
