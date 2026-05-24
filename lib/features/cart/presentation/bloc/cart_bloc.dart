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
  final ClearCartUseCase clearCartUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;

  CartBloc({
    required this.getCartItemsUseCase,
    required this.addCartItemUseCase,
    required this.removeCartItemUseCase,
    required this.clearCartUseCase,
    required this.updateCartItemUseCase,
  }) : super(const CartInitialState()) {
    on<GetCartItemsEvent>(_onGetCartItems);
    on<AddCartItemEvent>(_onAddCartItem);
    on<RemoveCartItemEvent>(_onRemoveCartItem);
    on<ClearCartEvent>(_onClearCart);
    on<UpdateCartItemEvent>(_onUpdateCartItem);
  }

  Future<void> _onGetCartItems(
    GetCartItemsEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoadingState());
    final result = await getCartItemsUseCase();
    result.fold(
      (failure) => emit(GetCartItemsErrorState(failure.message)),
      (items) => items.isEmpty
          ? emit(const CartEmptyState())
          : emit(GetCartItemsSuccessState(items)),
    );
  }

  Future<void> _onAddCartItem(
    AddCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    await addCartItemUseCase(
      productId: event.productId,
      productName: event.productName,
      productImage: event.productImage,
      price: event.price,
      quantity: event.quantity,
    );
    add(const GetCartItemsEvent());
  }

  Future<void> _onRemoveCartItem(
    RemoveCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    await removeCartItemUseCase(event.productId);
    add(const GetCartItemsEvent());
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    await clearCartUseCase();
    emit(const CartEmptyState());
  }

  Future<void> _onUpdateCartItem(
    UpdateCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    await updateCartItemUseCase(
      productId: event.productId,
      quantity: event.quantity,
    );
    add(const GetCartItemsEvent());
  }
}
