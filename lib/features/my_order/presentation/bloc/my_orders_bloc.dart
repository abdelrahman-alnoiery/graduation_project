import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_my_orders_usecase.dart';
import 'my_orders_event.dart';
import 'my_orders_state.dart';

class MyOrdersBloc extends Bloc<MyOrdersEvent, MyOrdersState> {
  final GetMyOrdersUseCase getMyOrdersUseCase;

  MyOrdersBloc({required this.getMyOrdersUseCase})
    : super(const MyOrdersInitialState()) {
    on<GetMyOrdersEvent>(_onGetMyOrders);
  }

  Future<void> _onGetMyOrders(
    GetMyOrdersEvent event,
    Emitter<MyOrdersState> emit,
  ) async {
    emit(const MyOrdersLoadingState());
    final result = await getMyOrdersUseCase();
    result.fold(
      (failure) => emit(MyOrdersErrorState(failure.message)),
      (orders) => emit(MyOrdersLoadedState(orders)),
    );
  }
}
