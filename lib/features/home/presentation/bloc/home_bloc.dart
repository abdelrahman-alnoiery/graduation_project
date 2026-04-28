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

  // ── Get Home Data ─────────────────────────────────
  Future<void> _onGetHomeData(
    GetHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoadingState());

    // ── Brands ────────────────────────────────────
    List<BrandEntity> brands = [];
    final brandsResult = await getBrandsUseCase();
    final brandsFailure = brandsResult.fold((f) => f, (data) {
      brands = data;
      return null;
    });
    if (brandsFailure != null) {
      emit(HomeDataErrorState(brandsFailure));
      return;
    }

    // ── Trends ────────────────────────────────────
    List<ProductEntity> trends = [];
    final trendsResult = await getTrendsUseCase();
    final trendsFailure = trendsResult.fold((f) => f, (data) {
      trends = data;
      return null;
    });
    if (trendsFailure != null) {
      emit(HomeDataErrorState(trendsFailure));
      return;
    }

    // ── Best Price ────────────────────────────────
    List<ProductEntity> bestPriceProducts = [];
    final bestPriceResult = await getBestPriceUseCase();
    final bestPriceFailure = bestPriceResult.fold((f) => f, (data) {
      bestPriceProducts = data;
      return null;
    });
    if (bestPriceFailure != null) {
      emit(HomeDataErrorState(bestPriceFailure));
      return;
    }

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
