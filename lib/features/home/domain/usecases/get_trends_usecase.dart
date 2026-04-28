import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/home/domain/repository/home_repo.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/product_entity.dart';

class GetTrendsUseCase {
  final HomeRepo homeRepo;

  GetTrendsUseCase(this.homeRepo);

  Future<Either<Failure, List<ProductEntity>>> call() async {
    return await homeRepo.getTrends();
  }
}
