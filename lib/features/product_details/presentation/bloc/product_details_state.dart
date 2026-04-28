import '../../../../core/exceptions/failuers.dart';
import '../../domain/entity/product_details_entity.dart';

abstract class ProductDetailsState {
  const ProductDetailsState();
}

class ProductDetailsInitialState extends ProductDetailsState {
  const ProductDetailsInitialState();
}

class ProductDetailsLoadingState extends ProductDetailsState {
  const ProductDetailsLoadingState();
}

class ProductDetailsSuccessState extends ProductDetailsState {
  final ProductDetailsEntity product;
  final String selectedColor;
  final String selectedSize;

  const ProductDetailsSuccessState({
    required this.product,
    required this.selectedColor,
    required this.selectedSize,
  });
}

class ProductDetailsErrorState extends ProductDetailsState {
  final Failure failure;
  const ProductDetailsErrorState(this.failure);
}

class ColorChangedState extends ProductDetailsState {
  final String selectedColor;
  const ColorChangedState(this.selectedColor);
}

class SizeChangedState extends ProductDetailsState {
  final String selectedSize;
  const SizeChangedState(this.selectedSize);
}
