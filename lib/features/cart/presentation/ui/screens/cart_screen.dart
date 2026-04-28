import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_state.dart';

import '../../../../../core/utils/color_maanger.dart';
import '../../../../../core/utils/components/main_button.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/empty_cart_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(const GetCartItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        // leading: Icon(Icons.arrow_back, color: Colors.white),
        backgroundColor: ColorManager.primary,
        title: Text(
          "My Cart",
          style: getBoldStyle(
            color: ColorManager.white,
            fontSize: FontSize.s20,
          ),
        ),
        actions: [
          // ── Clear Cart Button ──────────────────
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is GetCartItemsSuccessState) {
                return IconButton(
                  onPressed: () {
                    _showClearCartDialog(context);
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: ColorManager.white,
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is ClearCartSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Cart cleared successfully",
                  style: getRegularStyle(color: ColorManager.white),
                ),
                backgroundColor: ColorManager.success,
              ),
            );
          } else if (state is RemoveCartItemSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Item removed from cart",
                  style: getRegularStyle(color: ColorManager.white),
                ),
                backgroundColor: ColorManager.success,
              ),
            );
          } else if (state is GetCartItemsErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.failure.message,
                  style: getRegularStyle(color: ColorManager.white),
                ),
                backgroundColor: ColorManager.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: ColorManager.primary),
            );
          }

          if (state is CartEmptyState) {
            return const EmptyCartWidget();
          }

          if (state is GetCartItemsSuccessState) {
            return Column(
              children: [
                // ── Cart Items List ──────────────
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppPadding.p16),
                    itemCount: state.cartItems.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSize.s12),
                    itemBuilder: (context, index) {
                      final item = state.cartItems[index];
                      return CartItemWidget(
                        item: item,
                        onRemove: () {
                          context.read<CartBloc>().add(
                            RemoveCartItemEvent(item.productId),
                          );
                        },
                        onIncrement: () {
                          context.read<CartBloc>().add(
                            UpdateCartItemEvent(
                              productId: item.productId,
                              quantity: item.quantity + 1,
                            ),
                          );
                        },
                        onDecrement: () {
                          if (item.quantity > 1) {
                            context.read<CartBloc>().add(
                              UpdateCartItemEvent(
                                productId: item.productId,
                                quantity: item.quantity - 1,
                              ),
                            );
                          } else {
                            context.read<CartBloc>().add(
                              RemoveCartItemEvent(item.productId),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),

                // ── Order Summary ────────────────
                Container(
                  padding: const EdgeInsets.all(AppPadding.p16),
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.r24),
                      topRight: Radius.circular(AppRadius.r24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Items Count
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Items (${state.cartItems.length})",
                            style: getRegularStyle(
                              color: ColorManager.textSecondary,
                              fontSize: FontSize.s14,
                            ),
                          ),
                          Text(
                            "EGP ${state.totalPrice.toStringAsFixed(0)}",
                            style: getMediumStyle(
                              color: ColorManager.textPrimary,
                              fontSize: FontSize.s14,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSize.s8),
                      const Divider(color: ColorManager.lightGrey),
                      const SizedBox(height: AppSize.s8),

                      // Total Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: getBoldStyle(
                              color: ColorManager.textPrimary,
                              fontSize: FontSize.s16,
                            ),
                          ),
                          Text(
                            "EGP ${state.totalPrice.toStringAsFixed(0)}",
                            style: getBoldStyle(
                              color: ColorManager.primary,
                              fontSize: FontSize.s18,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSize.s16),

                      // Checkout Button
                      MainButton(
                        title: "Proceed to Checkout",
                        onPressed: () {
                          // ⚠️ هيتكمل لما الـ Backend يبعت الـ API
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Clear Cart",
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s18,
          ),
        ),
        content: Text(
          "Are you sure you want to clear your cart?",
          style: getRegularStyle(
            color: ColorManager.textSecondary,
            fontSize: FontSize.s14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: getMediumStyle(
                color: ColorManager.grey,
                fontSize: FontSize.s14,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CartBloc>().add(const ClearCartEvent());
            },
            child: Text(
              "Clear",
              style: getMediumStyle(
                color: ColorManager.error,
                fontSize: FontSize.s14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
