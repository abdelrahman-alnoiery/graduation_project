import '../../../home/domain/entity/product_entity.dart';

abstract class ProductsState {
  const ProductsState();
}

class ProductsInitialState extends ProductsState {
  const ProductsInitialState();
}

class ProductsLoadingState extends ProductsState {
  const ProductsLoadingState();
}

class ProductsSuccessState extends ProductsState {
  final List<ProductEntity> products;
  const ProductsSuccessState(this.products);
}

class ProductsEmptyState extends ProductsState {
  const ProductsEmptyState();
}

class ProductsErrorState extends ProductsState {
  final String message;
  const ProductsErrorState(this.message);
}
