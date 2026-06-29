import '../../domain/entity/order_entity.dart';

abstract class MyOrdersState {
  const MyOrdersState();
}

class MyOrdersInitialState extends MyOrdersState {
  const MyOrdersInitialState();
}

class MyOrdersLoadingState extends MyOrdersState {
  const MyOrdersLoadingState();
}

class MyOrdersLoadedState extends MyOrdersState {
  final List<OrderEntity> orders;
  const MyOrdersLoadedState(this.orders);
}

class MyOrdersErrorState extends MyOrdersState {
  final String message;
  const MyOrdersErrorState(this.message);
}
