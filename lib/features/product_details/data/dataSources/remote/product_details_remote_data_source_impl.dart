import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/features/product_details/data/models/product_details_model.dart';

import '../../../../../core/api/api_manger.dart';
import 'product_details_remote_data_source.dart';

class ProductDetailsRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSource {
  @override
  Future<ProductDetailsModel> getProductDetails(String productId) async {
    try {
      final response = await ApiManager.get(
        "${EndPoints.productDetails}/$productId",
      );
      return ProductDetailsModel.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }
}
