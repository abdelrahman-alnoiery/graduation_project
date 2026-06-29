import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';

import '../entity/order_entity.dart';
import '../repository/my_orders_repo.dart';

class GetMyOrdersUseCase {
  final MyOrdersRepo repo;
  GetMyOrdersUseCase(this.repo);

  Future<Either<Failure, List<OrderEntity>>> call() async {
    return await repo.getMyOrders();
  }
}
