import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/car_try_on_usecase.dart';
import 'car_try_on_event.dart';
import 'car_try_on_state.dart';

class CarTryOnBloc extends Bloc<CarTryOnEvent, CarTryOnState> {
  final CarTryOnUseCase carTryOnUseCase;

  CarTryOnBloc({required this.carTryOnUseCase})
    : super(CarTryOnInitialState()) {
    // 1. معالجة حدث إرسال الصورة للذكاء الاصطناعي
    on<TryOnCarEvent>((event, emit) async {
      emit(const CarTryOnLoadingState());

      print("🚀 BLoC catching TryOnCarEvent...");
      print("📦 Product ID: ${event.productId}");
      print("📦 Product Name: ${event.productName}");
      print("📦 Product Image URL: ${event.productImageUrl}");

      // ✅ تم الإصلاح: استدعاء الـ UseCase مباشرة كـ Callable Class بدون دالة .execute
      final result = await carTryOnUseCase(
        productId: event.productId,
        productName: event.productName,
        productImageUrl: event.productImageUrl,
        carImage: event.carImage,
      );

      // التعامل مع النتيجة القادمة
      result.fold(
        (failure) {
          print("❌ BLoC received error: ${failure.message}");
          // ✅ تم الإصلاح: تمرير الـ Parameter بدون اسم (Positional)
          emit(CarTryOnErrorState(failure.message));
        },
        (carTryOnEntity) {
          print("✅ BLoC received AI Result successfully!");
          // ✅ تم الإصلاح: تمرير الـ Parameter بدون اسم (Positional)
          emit(CarTryOnSuccessState(carTryOnEntity));
        },
      );
    });

    // 2. معالجة حدث إعادة التصفير (Reset)
    on<ResetCarTryOnEvent>((event, emit) {
      print("🔄 Resetting Car Try-On State to Initial.");
      emit(CarTryOnInitialState());
    });
  }
}
