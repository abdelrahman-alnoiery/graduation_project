import 'package:graduation_project/features/categories/data/models/category_model.dart';

import 'categories_remote_data_source.dart';

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  // ✅ الـ Backend مش عنده categories endpoint
  // هنستخدم static categories
  @override
  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      CategoryModel(id: 'Car Door', name: 'Car Door', image: '', icon: 'body'),
      CategoryModel(
        id: 'Auto Lighting Systems',
        name: 'Lighting',
        image: '',
        icon: 'electrical',
      ),
      CategoryModel(id: 'wheels', name: 'Wheels', image: '', icon: 'tires'),
      CategoryModel(
        id: 'car accessories',
        name: 'Accessories',
        image: '',
        icon: 'accessories',
      ),
      CategoryModel(
        id: 'Engine Parts',
        name: 'Engine Parts',
        image: '',
        icon: 'engine',
      ),
      CategoryModel(id: 'Brakes', name: 'Brakes', image: '', icon: 'brakes'),
      CategoryModel(
        id: 'Suspension',
        name: 'Suspension',
        image: '',
        icon: 'suspension',
      ),
      CategoryModel(
        id: 'Interior',
        name: 'Interior',
        image: '',
        icon: 'interior',
      ),
    ];
  }
}
