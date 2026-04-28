import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_cart_item_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/get_cart_items_usecase.dart';
import '../../domain/usecases/remove_cart_item_usecase.dart';
import '../../domain/usecases/update_cart_item_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUseCase getCartItemsUseCase;
  final AddCartItemUseCase addCartItemUseCase;
  final RemoveCartItemUseCase removeCartItemUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartBloc({
    required this.getCartItemsUseCase,
    required this.addCartItemUseCase,
    required this.removeCartItemUseCase,
    required this.updateCartItemUseCase,
    required this.clearCartUseCase,
  }) : super(const CartInitialState()) {
    on<GetCartItemsEvent>(_onGetCartItems);
    on<AddCartItemEvent>(_onAddCartItem);
    on<RemoveCartItemEvent>(_onRemoveCartItem);
    on<UpdateCartItemEvent>(_onUpdateCartItem);
    on<ClearCartEvent>(_onClearCart);
  }

  // ── Get Cart Items ────────────────────────────────
  Future<void> _onGetCartItems(
    GetCartItemsEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoadingState());
    final result = await getCartItemsUseCase();
    result.fold((failure) => emit(GetCartItemsErrorState(failure)), (items) {
      if (items.isEmpty) {
        emit(const CartEmptyState());
      } else {
        final totalPrice = items.fold(
          0.0,
          (sum, item) => sum + item.totalPrice,
        );
        emit(
          GetCartItemsSuccessState(cartItems: items, totalPrice: totalPrice),
        );
      }
    });
  }

  // ── Add Cart Item ─────────────────────────────────
  Future<void> _onAddCartItem(
    AddCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoadingState());
    final result = await addCartItemUseCase(
      productId: event.productId,
      productName: event.productName,
      productImage: event.productImage,
      price: event.price,
      quantity: event.quantity,
    );
    result.fold((failure) => emit(AddCartItemErrorState(failure)), (_) {
      emit(const AddCartItemSuccessState());
      add(const GetCartItemsEvent());
    });
  }

  // ── Remove Cart Item ──────────────────────────────
  Future<void> _onRemoveCartItem(
    RemoveCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoadingState());
    final result = await removeCartItemUseCase(event.productId);
    result.fold((failure) => emit(RemoveCartItemErrorState(failure)), (_) {
      emit(const RemoveCartItemSuccessState());
      add(const GetCartItemsEvent());
    });
  }

  // ── Update Cart Item ──────────────────────────────
  Future<void> _onUpdateCartItem(
    UpdateCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await updateCartItemUseCase(
      productId: event.productId,
      quantity: event.quantity,
    );
    result.fold((failure) => emit(UpdateCartItemErrorState(failure)), (_) {
      emit(const UpdateCartItemSuccessState());
      add(const GetCartItemsEvent());
    });
  }

  // ── Clear Cart ────────────────────────────────────
  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoadingState());
    final result = await clearCartUseCase();
    result.fold(
      (failure) => emit(ClearCartErrorState(failure)),
      (_) => emit(const ClearCartSuccessState()),
    );
  }
}
