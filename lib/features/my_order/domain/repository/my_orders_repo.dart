import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';

import '../entity/order_entity.dart';

abstract class MyOrdersRepo {
  Future<Either<Failure, List<OrderEntity>>> getMyOrders();
}
