import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/home/domain/repository/home_repo.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/product_entity.dart';

class GetBestPriceUseCase {
  final HomeRepo homeRepo;

  GetBestPriceUseCase(this.homeRepo);

  Future<Either<Failure, List<ProductEntity>>> call() async {
    return await homeRepo.getBestPriceProducts();
  }
}
