import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/cache/shared_pref.dart';
import 'package:graduation_project/features/add_product/domain/usecases/add_product_usecase.dart';

import 'add_product_event.dart';
import 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final AddProductUseCase addProductUseCase;

  AddProductBloc({required this.addProductUseCase})
    : super(const AddProductInitialState()) {
    on<SubmitAddProductEvent>(_onSubmit);
    on<ResetAddProductEvent>(_onReset);
  }

  Future<void> _onSubmit(
    SubmitAddProductEvent event,
    Emitter<AddProductState> emit,
  ) async {
    emit(const AddProductLoadingState());
    final result = await addProductUseCase(
      name: event.name,
      description: event.description,
      category: event.category,
      price: event.price,
      stock: event.stock,
      images: event.images,
    );

    // ✅ مش fold — عشان نقدر نعمل await جوا
    if (result.isLeft()) {
      final failure = result.fold((l) => l, (r) => null)!;
      emit(AddProductErrorState(failure.message));
    } else {
      final product = result.fold((l) => null, (r) => r)!;
      // ✅ امسح الـ cache
      await SharedPref.remove('cached_trending_products');
      await SharedPref.remove('cached_seller_products');
      emit(AddProductSuccessState(product));
    }
  }

  void _onReset(ResetAddProductEvent event, Emitter<AddProductState> emit) {
    emit(const AddProductInitialState());
  }
}
