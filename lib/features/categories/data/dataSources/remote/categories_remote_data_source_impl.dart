import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/features/categories/data/models/category_model.dart';

import '../../../../../core/api/api_manger.dart';
import 'categories_remote_data_source.dart';

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await ApiManager.get(EndPoints.categories);
      return (response.data['categories'] as List)
          .map((category) => CategoryModel.fromJson(category))
          .toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }
}
