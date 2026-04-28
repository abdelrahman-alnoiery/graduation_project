import '../../../../core/exceptions/failuers.dart';
import '../../domain/entity/brand_entity.dart';
import '../../domain/entity/product_entity.dart';

abstract class HomeState {
  const HomeState();
}

// ── Initial ───────────────────────────────────────
class HomeInitialState extends HomeState {
  const HomeInitialState();
}

// ── Loading ───────────────────────────────────────
class HomeLoadingState extends HomeState {
  const HomeLoadingState();
}

// ── Home Data Success ─────────────────────────────
class HomeDataSuccessState extends HomeState {
  final List<BrandEntity> brands;
  final List<ProductEntity> trends;
  final List<ProductEntity> bestPriceProducts;

  const HomeDataSuccessState({
    required this.brands,
    required this.trends,
    required this.bestPriceProducts,
  });
}

// ── Home Data Error ───────────────────────────────
class HomeDataErrorState extends HomeState {
  final Failure failure;
  const HomeDataErrorState(this.failure);
}

// ── Search ────────────────────────────────────────
class SearchLoadingState extends HomeState {
  const SearchLoadingState();
}

class SearchSuccessState extends HomeState {
  final List<ProductEntity> products;
  const SearchSuccessState(this.products);
}

class SearchErrorState extends HomeState {
  final Failure failure;
  const SearchErrorState(this.failure);
}

class SearchEmptyState extends HomeState {
  const SearchEmptyState();
}
