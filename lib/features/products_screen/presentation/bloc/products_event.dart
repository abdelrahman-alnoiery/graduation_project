abstract class ProductsEvent {
  const ProductsEvent();
}

class GetProductsEvent extends ProductsEvent {
  final String? categoryId;
  const GetProductsEvent({this.categoryId});
}
