import '../../domain/entity/add_product_entity.dart';

abstract class AddProductState {
  const AddProductState();
}

class AddProductInitialState extends AddProductState {
  const AddProductInitialState();
}

class AddProductLoadingState extends AddProductState {
  const AddProductLoadingState();
}

class AddProductSuccessState extends AddProductState {
  final AddProductEntity product;
  const AddProductSuccessState(this.product);
}

class AddProductErrorState extends AddProductState {
  final String message;
  const AddProductErrorState(this.message);
}
