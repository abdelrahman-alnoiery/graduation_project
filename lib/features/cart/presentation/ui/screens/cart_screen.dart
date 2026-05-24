import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_state.dart';

import '../../../../../core/utils/color_maanger.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: ColorManager.white),
        ),
        title: Text(
          "My Cart",
          style: getBoldStyle(
            color: ColorManager.white,
            fontSize: FontSize.s18,
          ),
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is GetCartItemsSuccessState &&
                  state.cartItems.isNotEmpty) {
                return TextButton(
                  onPressed: () =>
                      context.read<CartBloc>().add(const ClearCartEvent()),
                  child: Text(
                    "Clear",
                    style: getMediumStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s14,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          // ── Loading ──────────────────────────────
          if (state is CartLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: ColorManager.primary),
            );
          }

          // ── Empty ────────────────────────────────
          if (state is CartEmptyState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    color: ColorManager.grey,
                    size: AppSize.s80,
                  ),
                  const SizedBox(height: AppSize.s16),
                  Text(
                    "Your Cart is Empty",
                    style: getBoldStyle(
                      color: ColorManager.textPrimary,
                      fontSize: FontSize.s20,
                    ),
                  ),
                  const SizedBox(height: AppSize.s8),
                  Text(
                    "Add products to your cart\nto see them here",
                    style: getRegularStyle(
                      color: ColorManager.textSecondary,
                      fontSize: FontSize.s14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // ── Success ──────────────────────────────
          if (state is GetCartItemsSuccessState) {
            final items = state.cartItems;
            final total = items.fold(0.0, (sum, item) => sum + item.totalPrice);

            return Column(
              children: [
                // ── Items List ──────────────────
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppPadding.p16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppMargin.m12),
                        decoration: BoxDecoration(
                          color: ColorManager.white,
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                          boxShadow: [
                            BoxShadow(
                              color: ColorManager.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppPadding.p12),
                          child: Row(
                            children: [
                              // ── Image ──────────
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.r8,
                                ),
                                child: item.image.isNotEmpty
                                    ? Image.network(
                                        item.image,
                                        width: AppSize.s80,
                                        height: AppSize.s80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            _buildImageError(),
                                      )
                                    : _buildImageError(),
                              ),

                              const SizedBox(width: AppSize.s12),

                              // ── Info ───────────
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: getMediumStyle(
                                        color: ColorManager.textPrimary,
                                        fontSize: FontSize.s14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: AppSize.s4),
                                    Text(
                                      "EGP ${item.price.toStringAsFixed(0)}",
                                      style: getRegularStyle(
                                        color: ColorManager.textSecondary,
                                        fontSize: FontSize.s12,
                                      ),
                                    ),
                                    const SizedBox(height: AppSize.s8),

                                    // ── Quantity ──
                                    Row(
                                      children: [
                                        _buildQuantityButton(
                                          icon: Icons.remove,
                                          onTap: () {
                                            if (item.quantity > 1) {
                                              context.read<CartBloc>().add(
                                                UpdateCartItemEvent(
                                                  productId: item.id,
                                                  quantity: item.quantity - 1,
                                                ),
                                              );
                                            } else {
                                              context.read<CartBloc>().add(
                                                RemoveCartItemEvent(item.id),
                                              );
                                            }
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppPadding.p12,
                                          ),
                                          child: Text(
                                            "${item.quantity}",
                                            style: getBoldStyle(
                                              color: ColorManager.textPrimary,
                                              fontSize: FontSize.s14,
                                            ),
                                          ),
                                        ),
                                        _buildQuantityButton(
                                          icon: Icons.add,
                                          onTap: () {
                                            context.read<CartBloc>().add(
                                              UpdateCartItemEvent(
                                                productId: item.id,
                                                quantity: item.quantity + 1,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // ── Total & Delete ─
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "EGP ${item.totalPrice.toStringAsFixed(0)}",
                                    style: getBoldStyle(
                                      color: ColorManager.primary,
                                      fontSize: FontSize.s14,
                                    ),
                                  ),
                                  const SizedBox(height: AppSize.s8),
                                  GestureDetector(
                                    onTap: () => context.read<CartBloc>().add(
                                      RemoveCartItemEvent(item.id),
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline,
                                      color: ColorManager.error,
                                      size: AppSize.s20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ── Total & Checkout ────────────
                Container(
                  padding: const EdgeInsets.all(AppPadding.p16),
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // ── Total ──────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total:",
                            style: getMediumStyle(
                              color: ColorManager.textPrimary,
                              fontSize: FontSize.s16,
                            ),
                          ),
                          Text(
                            "EGP ${total.toStringAsFixed(0)}",
                            style: getBoldStyle(
                              color: ColorManager.primary,
                              fontSize: FontSize.s20,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSize.s16),

                      // ── Checkout Button ────────
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Checkout
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Order placed successfully!"),
                                backgroundColor: ColorManager.success,
                              ),
                            );
                            context.read<CartBloc>().add(
                              const ClearCartEvent(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primary,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppPadding.p16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.r12,
                              ),
                            ),
                          ),
                          child: Text(
                            "Checkout",
                            style: getBoldStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s16,
                            ),
                          ),
                        ),
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

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p4),
        decoration: BoxDecoration(
          color: ColorManager.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppRadius.r4),
        ),
        child: Icon(icon, color: ColorManager.primary, size: AppSize.s16),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      width: AppSize.s80,
      height: AppSize.s80,
      color: ColorManager.lightGrey,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: ColorManager.grey,
      ),
    );
  }
}
