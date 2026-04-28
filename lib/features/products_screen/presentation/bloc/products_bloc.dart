import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_all_products_usecase.dart';
import '../../domain/usecases/get_products_by_category_usecase.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;
  final GetAllProductsUseCase getAllProductsUseCase;

  ProductsBloc({
    required this.getProductsByCategoryUseCase,
    required this.getAllProductsUseCase,
  }) : super(const ProductsInitialState()) {
    on<GetProductsByCategoryEvent>(_onGetProductsByCategory);
    on<GetAllProductsEvent>(_onGetAllProducts);
  }

  Future<void> _onGetProductsByCategory(
    GetProductsByCategoryEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoadingState());
    final result = await getProductsByCategoryUseCase(event.categoryId);
    result.fold((failure) => emit(ProductsErrorState(failure)), (products) {
      if (products.isEmpty) {
        emit(const ProductsEmptyState());
      } else {
        emit(ProductsSuccessState(products));
      }
    });
  }

  Future<void> _onGetAllProducts(
    GetAllProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoadingState());
    final result = await getAllProductsUseCase();
    result.fold((failure) => emit(ProductsErrorState(failure)), (products) {
      if (products.isEmpty) {
        emit(const ProductsEmptyState());
      } else {
        emit(ProductsSuccessState(products));
      }
    });
  }
}
