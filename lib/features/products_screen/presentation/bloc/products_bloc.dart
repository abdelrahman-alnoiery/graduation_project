import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_products_by_category_usecase.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase getProductsUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  ProductsBloc({
    required this.getProductsUseCase,
    required this.getProductsByCategoryUseCase,
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
        : await getProductsUseCase();

    result.fold((failure) => emit(ProductsErrorState(failure.message)), (
      products,
    ) {
      // ✅ Filter by search query locally
      var filtered = products;
      if (event.searchQuery != null && event.searchQuery!.isNotEmpty) {
        filtered = products
            .where(
              (p) => p.name.toLowerCase().contains(
                event.searchQuery!.toLowerCase(),
              ),
            )
            .toList();
      }
      filtered.isEmpty
          ? emit(const ProductsEmptyState())
          : emit(ProductsSuccessState(filtered));
    });
  }
}
