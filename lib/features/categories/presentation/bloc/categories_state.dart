import '../../../../core/exceptions/failuers.dart';
import '../../domain/entity/category_entity.dart';

abstract class CategoriesState {
  const CategoriesState();
}

class CategoriesInitialState extends CategoriesState {
  const CategoriesInitialState();
}

class CategoriesLoadingState extends CategoriesState {
  const CategoriesLoadingState();
}

class CategoriesSuccessState extends CategoriesState {
  final List<CategoryEntity> categories;
  const CategoriesSuccessState(this.categories);
}

class CategoriesErrorState extends CategoriesState {
  final Failure failure;
  const CategoriesErrorState(this.failure);
}
