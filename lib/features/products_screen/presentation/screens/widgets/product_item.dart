import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_bloc.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_event.dart';

import '../../../../../core/utils/color_maanger.dart';
import '../../../../../core/utils/components/heart_button.dart';
import '../../../../home/domain/entity/product_entity.dart';

class ProductItem extends StatelessWidget {
  final ProductEntity product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.productDetails, arguments: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          boxShadow: [
            BoxShadow(
              color: ColorManager.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Product Image ──────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.r12),
                    topRight: Radius.circular(AppRadius.r12),
                  ),
                  child: Image.network(
                    product.image,
                    height: AppSize.s120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: AppSize.s120,
                      color: ColorManager.lightGrey,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: ColorManager.grey,
                      ),
                    ),
                  ),
                ),

                // Heart Button
                Positioned(
                  top: AppSize.s8,
                  right: AppSize.s8,
                  child: Container(
                    padding: const EdgeInsets.all(AppPadding.p4),
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.grey.withOpacity(0.2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: HeartButton(
                      isFavorite: product.isFavorite,
                      onTap: () {
                        if (product.isFavorite) {
                          context.read<FavouriteBloc>().add(
                            RemoveFavouriteEvent(product.id),
                          );
                        } else {
                          context.read<FavouriteBloc>().add(
                            AddFavouriteEvent(product.id),
                          );
                        }
                      },
                      size: AppSize.s20,
                    ),
                  ),
                ),
              ],
            ),

            // ── Product Info ───────────────────
            Padding(
              padding: const EdgeInsets.all(AppPadding.p8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: getMediumStyle(
                      color: ColorManager.textPrimary,
                      fontSize: FontSize.s12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppSize.s4),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "EGP ${product.price.toStringAsFixed(0)}",
                            style: getBoldStyle(
                              color: ColorManager.primary,
                              fontSize: FontSize.s12,
                            ),
                          ),
                          Text(
                            "EGP ${product.oldPrice.toStringAsFixed(0)}",
                            style: getRegularStyle(
                              color: ColorManager.grey,
                              fontSize: FontSize.s10,
                            ).copyWith(decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),

                      // Add to Cart
                      GestureDetector(
                        onTap: () {
                          context.read<CartBloc>().add(
                            AddCartItemEvent(
                              productId: product.id,
                              productName: product.name,
                              productImage: product.image,
                              price: product.price,
                              quantity: 1,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(AppPadding.p4),
                          decoration: BoxDecoration(
                            color: ColorManager.primary,
                            borderRadius: BorderRadius.circular(AppRadius.r8),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart_outlined,
                            color: ColorManager.white,
                            size: AppSize.s16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSize.s4),

                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: AppSize.s12,
                      ),
                      const SizedBox(width: AppSize.s4),
                      Text(
                        "Review (${product.reviewCount})",
                        style: getRegularStyle(
                          color: ColorManager.grey,
                          fontSize: FontSize.s10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
