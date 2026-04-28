import 'package:graduation_project/features/products_screen/data/models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProductsByCategory(String categoryId);
  Future<List<ProductModel>> getAllProducts();
}
