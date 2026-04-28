abstract class ProductDetailsEvent {
  const ProductDetailsEvent();
}

class GetProductDetailsEvent extends ProductDetailsEvent {
  final String productId;
  const GetProductDetailsEvent(this.productId);
}

class ChangeColorEvent extends ProductDetailsEvent {
  final String color;
  const ChangeColorEvent(this.color);
}

class ChangeSizeEvent extends ProductDetailsEvent {
  final String size;
  const ChangeSizeEvent(this.size);
}

class ToggleFavouriteEvent extends ProductDetailsEvent {
  final String productId;
  const ToggleFavouriteEvent(this.productId);
}
