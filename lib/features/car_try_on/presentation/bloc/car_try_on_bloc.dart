import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/car_try_on_usecase.dart';
import 'car_try_on_event.dart';
import 'car_try_on_state.dart';

class CarTryOnBloc extends Bloc<CarTryOnEvent, CarTryOnState> {
  final CarTryOnUseCase carTryOnUseCase;

  CarTryOnBloc({required this.carTryOnUseCase})
    : super(const CarTryOnInitialState()) {
    on<TryOnCarEvent>(_onTryOn);
    on<ResetCarTryOnEvent>(_onReset);
  }

  Future<void> _onTryOn(
    TryOnCarEvent event,
    Emitter<CarTryOnState> emit,
  ) async {
    emit(const CarTryOnLoadingState());

    final result = await carTryOnUseCase(
      productId: event.productId,
      carImage: event.carImage,
      productImageUrl: event.productImageUrl, // ✅
    );

    result.fold(
      (failure) => emit(CarTryOnErrorState(failure.message)),
      (entity) => emit(CarTryOnSuccessState(entity)),
    );
  }

  void _onReset(ResetCarTryOnEvent event, Emitter<CarTryOnState> emit) {
    emit(const CarTryOnInitialState());
  }
}
