import 'package:graduation_project/features/categories/data/models/category_model.dart';

abstract class CategoriesRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}
