import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/home/domain/repository/home_repo.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/product_entity.dart';

class SearchProductsUseCase {
  final HomeRepo homeRepo;

  SearchProductsUseCase(this.homeRepo);

  Future<Either<Failure, List<ProductEntity>>> call(String query) async {
    return await homeRepo.searchProducts(query);
  }
}
