import '../models/order_model.dart';

abstract class MyOrdersRemoteDatasource {
  Future<List<OrderModel>> getMyOrders();
}
