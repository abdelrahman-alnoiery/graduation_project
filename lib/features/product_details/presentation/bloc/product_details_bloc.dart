import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/favourite/domain/entity/favourite_entity.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_bloc.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_event.dart';

import '../../domain/usecases/get_product_details_usecase.dart';
import 'product_details_event.dart';
import 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final GetProductDetailsUseCase getProductDetailsUseCase;
  final FavouriteBloc favouriteBloc;

  String _selectedColor = '';
  String _selectedSize = '';

  ProductDetailsBloc({
    required this.getProductDetailsUseCase,
    required this.favouriteBloc,
  }) : super(const ProductDetailsInitialState()) {
    on<GetProductDetailsEvent>(_onGetProductDetails);
    on<ChangeColorEvent>(_onChangeColor);
    on<ChangeSizeEvent>(_onChangeSize);
    on<ToggleFavouriteEvent>(_onToggleFavourite);
  }

  // ── Get Product Details ───────────────────────────
  Future<void> _onGetProductDetails(
    GetProductDetailsEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(const ProductDetailsLoadingState());
    final result = await getProductDetailsUseCase(event.productId);
    result.fold((failure) => emit(ProductDetailsErrorState(failure)), (
      product,
    ) {
      _selectedColor = product.colors.isNotEmpty ? product.colors.first : '';
      _selectedSize = product.sizes.isNotEmpty ? product.sizes.first : '';
      emit(
        ProductDetailsSuccessState(
          product: product,
          selectedColor: _selectedColor,
          selectedSize: _selectedSize,
        ),
      );
    });
  }

  // ── Change Color ──────────────────────────────────
  void _onChangeColor(
    ChangeColorEvent event,
    Emitter<ProductDetailsState> emit,
  ) {
    _selectedColor = event.color;
    emit(ColorChangedState(_selectedColor));
  }

  // ── Change Size ───────────────────────────────────
  void _onChangeSize(ChangeSizeEvent event, Emitter<ProductDetailsState> emit) {
    _selectedSize = event.size;
    emit(SizeChangedState(_selectedSize));
  }

  // ── Toggle Favourite ──────────────────────────────
  void _onToggleFavourite(
    ToggleFavouriteEvent event,
    Emitter<ProductDetailsState> emit,
  ) {
    final currentState = state;
    if (currentState is ProductDetailsSuccessState) {
      if (currentState.product.isFavorite) {
        favouriteBloc.add(RemoveFavouriteEvent(event.productId));
      } else {
        favouriteBloc.add(
          AddFavouriteEvent(event.productId as FavouriteEntity),
        );
      }
    }
  }
}
