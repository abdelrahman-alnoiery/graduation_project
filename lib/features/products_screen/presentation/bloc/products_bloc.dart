import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/products_screen/domain/usecases/get_all_products_usecase.dart';

import '../../domain/usecases/get_products_by_category_usecase.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetAllProductsUseCase getAllProductsUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  ProductsBloc({
    required this.getAllProductsUseCase,
    required this.getProductsByCategoryUseCase,
    required GetAllProductsUsecase,
  }) : super(const ProductsInitialState()) {
    on<GetProductsEvent>(_onGetProducts);
  }

  Future<void> _onGetProducts(
    GetProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoadingState());

    final result = event.categoryId != null
        ? await getProductsByCategoryUseCase(event.categoryId!)
        : await getAllProductsUseCase();

    result.fold(
      (failure) => emit(ProductsErrorState(failure.message)),
      (products) => products.isEmpty
          ? emit(const ProductsEmptyState())
          : emit(ProductsSuccessState(products)),
    );
  }
}
