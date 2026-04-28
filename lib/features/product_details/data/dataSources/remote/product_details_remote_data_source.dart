import 'package:graduation_project/features/product_details/data/models/product_details_model.dart';

abstract class ProductDetailsRemoteDataSource {
  Future<ProductDetailsModel> getProductDetails(String productId);
}
