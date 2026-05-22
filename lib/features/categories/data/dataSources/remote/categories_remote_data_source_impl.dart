import 'package:graduation_project/features/categories/data/models/category_model.dart';

import 'categories_remote_data_source.dart';

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  // ✅ الـ Backend مش عنده categories endpoint
  // هنستخدم static categories
  @override
  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      CategoryModel(id: '1', name: 'Engine Parts', image: '', icon: 'engine'),
      CategoryModel(id: '2', name: 'Body Parts', image: '', icon: 'body'),
      CategoryModel(id: '3', name: 'Electrical', image: '', icon: 'electrical'),
      CategoryModel(id: '4', name: 'Brakes', image: '', icon: 'brakes'),
      CategoryModel(id: '5', name: 'Suspension', image: '', icon: 'suspension'),
      CategoryModel(id: '6', name: 'Tires & Wheels', image: '', icon: 'tires'),
      CategoryModel(id: '7', name: 'Interior', image: '', icon: 'interior'),
      CategoryModel(
        id: '8',
        name: 'Accessories',
        image: '',
        icon: 'accessories',
      ),
    ];
  }
}
