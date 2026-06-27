import '../../domain/entity/car_try_on_entity.dart';

abstract class CarTryOnState {
  const CarTryOnState();
}

class CarTryOnInitialState extends CarTryOnState {
  const CarTryOnInitialState();
}

class CarTryOnLoadingState extends CarTryOnState {
  const CarTryOnLoadingState();
}

class CarTryOnSuccessState extends CarTryOnState {
  final CarTryOnEntity result;
  const CarTryOnSuccessState(this.result);
}

class CarTryOnErrorState extends CarTryOnState {
  final String message;
  const CarTryOnErrorState(this.message);
}
