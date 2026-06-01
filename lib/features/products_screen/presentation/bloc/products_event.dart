abstract class ProductsEvent {
  const ProductsEvent();
}

class GetProductsEvent extends ProductsEvent {
  final String? categoryId;
  final String? searchQuery;

  const GetProductsEvent({this.categoryId, this.searchQuery});
}
