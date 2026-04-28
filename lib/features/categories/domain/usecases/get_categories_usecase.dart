import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/categories/domain/repository/categories_repo.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/category_entity.dart';

class GetCategoriesUseCase {
  final CategoriesRepo categoriesRepo;

  GetCategoriesUseCase(this.categoriesRepo);

  Future<Either<Failure, List<CategoryEntity>>> call() async {
    return await categoriesRepo.getCategories();
  }
}
