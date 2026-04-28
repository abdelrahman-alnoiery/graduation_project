import 'package:graduation_project/features/home/data/models/brand_model.dart';
import 'package:graduation_project/features/home/data/models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> getBestPriceProducts();
  Future<List<BrandModel>> getBrands();
  Future<List<ProductModel>> getTrends();
  Future<List<ProductModel>> searchProducts(String query);
}
