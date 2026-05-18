import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/brand_entity.dart';
import '../../domain/entity/product_entity.dart';
import '../../domain/usecases/get_best_price_usecase.dart';
import '../../domain/usecases/get_brands_usecase.dart';
import '../../domain/usecases/get_trends_usecase.dart';
import '../../domain/usecases/search_products_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetBrandsUseCase getBrandsUseCase;
  final GetTrendsUseCase getTrendsUseCase;
  final GetBestPriceUseCase getBestPriceUseCase;
  final SearchProductsUseCase searchProductsUseCase;

  HomeBloc({
    required this.getBrandsUseCase,
    required this.getTrendsUseCase,
    required this.getBestPriceUseCase,
    required this.searchProductsUseCase,
  }) : super(const HomeInitialState()) {
    on<GetHomeDataEvent>(_onGetHomeData);
    on<SearchProductsEvent>(_onSearchProducts);
  }

  Future<void> _onGetHomeData(
    GetHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoadingState());

    // ── Brands (static - مش محتاج API) ───────────
    List<BrandEntity> brands = [];
    final brandsResult = await getBrandsUseCase();
    brandsResult.fold((f) => brands = [], (data) => brands = data);

    // ── Trends ─────────────────────────────────────
    List<ProductEntity> trends = [];
    final trendsResult = await getTrendsUseCase();
    trendsResult.fold((f) => trends = [], (data) => trends = data);

    // ── Best Price ─────────────────────────────────
    List<ProductEntity> bestPriceProducts = [];
    final bestPriceResult = await getBestPriceUseCase();
    bestPriceResult.fold(
      (f) => bestPriceProducts = [],
      (data) => bestPriceProducts = data,
    );

    // ✅ دايماً هيعمل success حتى لو الـ data فاضية
    emit(
      HomeDataSuccessState(
        brands: brands,
        trends: trends,
        bestPriceProducts: bestPriceProducts,
      ),
    );
  }

  // ── Search Products ───────────────────────────────
  Future<void> _onSearchProducts(
    SearchProductsEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(const GetHomeDataEvent());
      return;
    }
    emit(const SearchLoadingState());
    final result = await searchProductsUseCase(event.query);
    result.fold((failure) => emit(SearchErrorState(failure)), (products) {
      if (products.isEmpty) {
        emit(const SearchEmptyState());
      } else {
        emit(SearchSuccessState(products));
      }
    });
  }
}
