import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_bloc.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_event.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_state.dart';

import '../../../../core/utils/color_maanger.dart';
import '../../../car_try_on/presentation/ui/car_try_on_screen.dart';
import '../../../favourite/domain/entity/favourite_entity.dart';
import '../../../home/domain/entity/product_entity.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductEntity product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Column(
        children: [
          // ── Body ──────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Product Image ────────────────
                  Stack(
                    children: [
                      // ── Image ──────────────────
                      SizedBox(
                        width: double.infinity,
                        height: AppSize.s300,
                        child: product.image.isNotEmpty
                            ? Image.network(
                                product.image,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Container(
                                    color: ColorManager.lightGrey,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: ColorManager.primary,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (_, __, ___) =>
                                    _buildImageError(),
                              )
                            : _buildImageError(),
                      ),

                      // ── Back Button ────────────
                      Positioned(
                        top: AppSize.s48,
                        left: AppSize.s16,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(AppPadding.p8),
                            decoration: BoxDecoration(
                              color: ColorManager.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: ColorManager.grey.withOpacity(0.3),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: ColorManager.textPrimary,
                              size: AppSize.s20,
                            ),
                          ),
                        ),
                      ),

                      // ── Favourite Button ───────
                      Positioned(
                        top: AppSize.s48,
                        right: AppSize.s16,
                        child: BlocBuilder<FavouriteBloc, FavouriteState>(
                          builder: (context, state) {
                            final isFav =
                                state is FavouriteSuccessState &&
                                state.favourites.any((f) => f.id == product.id);
                            return GestureDetector(
                              onTap: () {
                                if (isFav) {
                                  context.read<FavouriteBloc>().add(
                                    RemoveFavouriteEvent(product.id),
                                  );
                                } else {
                                  context.read<FavouriteBloc>().add(
                                    AddFavouriteEvent(
                                      FavouriteEntity(
                                        id: product.id,
                                        name: product.name,
                                        image: product.image,
                                        price: product.price,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(AppPadding.p8),
                                decoration: BoxDecoration(
                                  color: ColorManager.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorManager.grey.withOpacity(0.3),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFav
                                      ? ColorManager.error
                                      : ColorManager.grey,
                                  size: AppSize.s24,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  // ── Product Info ─────────────────
                  Padding(
                    padding: const EdgeInsets.all(AppPadding.p16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Name ──────────────────
                        Text(
                          product.name,
                          style: getBoldStyle(
                            color: ColorManager.textPrimary,
                            fontSize: FontSize.s20,
                          ),
                        ),

                        const SizedBox(height: AppSize.s8),

                        // ── Price & Rating ────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "EGP ${product.price.toStringAsFixed(0)}",
                              style: getBoldStyle(
                                color: ColorManager.primary,
                                fontSize: FontSize.s24,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: AppSize.s20,
                                ),
                                const SizedBox(width: AppSize.s4),
                                Text(
                                  product.rating.toStringAsFixed(1),
                                  style: getMediumStyle(
                                    color: ColorManager.textPrimary,
                                    fontSize: FontSize.s14,
                                  ),
                                ),
                                const SizedBox(width: AppSize.s4),
                                Text(
                                  "(${product.reviewCount} reviews)",
                                  style: getRegularStyle(
                                    color: ColorManager.textSecondary,
                                    fontSize: FontSize.s12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSize.s16),
                        const Divider(color: ColorManager.lightGrey),
                        const SizedBox(height: AppSize.s16),

                        // ── Quantity ──────────────
                        Row(
                          children: [
                            Text(
                              "Quantity:",
                              style: getMediumStyle(
                                color: ColorManager.textPrimary,
                                fontSize: FontSize.s16,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: ColorManager.lightGrey,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.r8,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // ── Minus ───────
                                  IconButton(
                                    onPressed: () {
                                      if (_quantity > 1) {
                                        setState(() => _quantity--);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.remove,
                                      color: ColorManager.primary,
                                      size: AppSize.s20,
                                    ),
                                  ),

                                  // ── Count ───────
                                  Text(
                                    "$_quantity",
                                    style: getBoldStyle(
                                      color: ColorManager.textPrimary,
                                      fontSize: FontSize.s16,
                                    ),
                                  ),

                                  // ── Plus ────────
                                  IconButton(
                                    onPressed: () {
                                      setState(() => _quantity++);
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      color: ColorManager.primary,
                                      size: AppSize.s20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSize.s16),
                        const Divider(color: ColorManager.lightGrey),
                        const SizedBox(height: AppSize.s16),

                        // ── Description ───────────
                        Text(
                          "Description",
                          style: getBoldStyle(
                            color: ColorManager.textPrimary,
                            fontSize: FontSize.s16,
                          ),
                        ),
                        const SizedBox(height: AppSize.s8),
                        Text(
                          "High quality car accessory for your vehicle. "
                          "Compatible with multiple car models. "
                          "Durable and reliable product that meets "
                          "international quality standards.",
                          style: getRegularStyle(
                            color: ColorManager.textSecondary,
                            fontSize: FontSize.s14,
                          ),
                        ),

                        const SizedBox(height: AppSize.s16),

                        // ── Total Price ───────────
                        Container(
                          padding: const EdgeInsets.all(AppPadding.p16),
                          decoration: BoxDecoration(
                            color: ColorManager.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(AppRadius.r12),
                            border: Border.all(
                              color: ColorManager.primary.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Price:",
                                style: getMediumStyle(
                                  color: ColorManager.textPrimary,
                                  fontSize: FontSize.s16,
                                ),
                              ),
                              Text(
                                "EGP ${(product.price * _quantity).toStringAsFixed(0)}",
                                style: getBoldStyle(
                                  color: ColorManager.primary,
                                  fontSize: FontSize.s20,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSize.s16),

                        // ── Compatible Cars ───────
                        if (product.categoryId.isNotEmpty) ...[
                          Text(
                            "Category",
                            style: getBoldStyle(
                              color: ColorManager.textPrimary,
                              fontSize: FontSize.s16,
                            ),
                          ),
                          const SizedBox(height: AppSize.s8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppPadding.p12,
                              vertical: AppPadding.p6,
                            ),
                            decoration: BoxDecoration(
                              color: ColorManager.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppRadius.r8),
                            ),
                            child: Text(
                              product.categoryId,
                              style: getMediumStyle(
                                color: ColorManager.primary,
                                fontSize: FontSize.s12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom Buttons ────────────────────────
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
              // ✅ غيرنا Row لـ Column عشان نضيف زرار تاني
              children: [
                // ── Try on Your Car Button ────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CarTryOnScreen(
                            productId: product.id,
                            productName: product.name,
                            productImage: product.image,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.directions_car_rounded,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Try on Your Car 🚗",
                      style: getBoldStyle(
                        color: Colors.white,
                        fontSize: FontSize.s15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1a237e),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppPadding.p14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSize.s8),

                // ── Row: Favourite + Add to Cart ──────────
                Row(
                  children: [
                    // ── Favourite Button ─────────────────
                    BlocBuilder<FavouriteBloc, FavouriteState>(
                      builder: (context, state) {
                        final isFav =
                            state is FavouriteSuccessState &&
                            state.favourites.any((f) => f.id == product.id);
                        return Container(
                          margin: const EdgeInsets.only(right: AppMargin.m12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isFav
                                  ? ColorManager.error
                                  : ColorManager.lightGrey,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.r12),
                          ),
                          child: IconButton(
                            onPressed: () {
                              if (isFav) {
                                context.read<FavouriteBloc>().add(
                                  RemoveFavouriteEvent(product.id),
                                );
                              } else {
                                context.read<FavouriteBloc>().add(
                                  AddFavouriteEvent(
                                    FavouriteEntity(
                                      id: product.id,
                                      name: product.name,
                                      image: product.image,
                                      price: product.price,
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav
                                  ? ColorManager.error
                                  : ColorManager.grey,
                            ),
                          ),
                        );
                      },
                    ),

                    // ── Add to Cart Button ────────────────
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<CartBloc>().add(
                            AddCartItemEvent(
                              productId: product.id,
                              productName: product.name,
                              productImage: product.image,
                              price: product.price,
                              quantity: _quantity,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${product.name} added to cart!"),
                              backgroundColor: ColorManager.success,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          color: ColorManager.white,
                        ),
                        label: Text(
                          "Add to Cart",
                          style: getBoldStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppPadding.p16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.r12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Image Error ───────────────────────────────────
  Widget _buildImageError() {
    return Container(
      width: double.infinity,
      height: AppSize.s300,
      color: ColorManager.lightGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.directions_car,
            color: ColorManager.primary,
            size: AppSize.s60,
          ),
          const SizedBox(height: AppSize.s8),
          Text(
            widget.product.name,
            style: getMediumStyle(
              color: ColorManager.textSecondary,
              fontSize: FontSize.s14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
