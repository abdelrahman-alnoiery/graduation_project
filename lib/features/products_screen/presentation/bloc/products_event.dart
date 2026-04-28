abstract class ProductsEvent {
  const ProductsEvent();
}

class GetProductsByCategoryEvent extends ProductsEvent {
  final String categoryId;
  const GetProductsByCategoryEvent(this.categoryId);
}

class GetAllProductsEvent extends ProductsEvent {
  const GetAllProductsEvent();
}
