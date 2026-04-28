import 'package:flutter/material.dart';

import '../color_maanger.dart';
import '../font_manager.dart';
import '../styles_manager.dart';
import '../values_manager.dart';
import 'heart_button.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  final String productImage;
  final double price;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onCardTap;
  final VoidCallback onAddToCartTap;

  const ProductCard({
    super.key,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onCardTap,
    required this.onAddToCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          boxShadow: [
            BoxShadow(
              color: ColorManager.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Product Image ─────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.r12),
                    topRight: Radius.circular(AppRadius.r12),
                  ),
                  child: Image.network(
                    productImage,
                    height: AppSize.s120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
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
                      isFavorite: isFavorite,
                      onTap: onFavoriteTap,
                      size: AppSize.s20,
                    ),
                  ),
                ),
              ],
            ),

            // ── Product Info ──────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppPadding.p8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    productName,
                    style: getMediumStyle(
                      color: ColorManager.textPrimary,
                      fontSize: FontSize.s12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: AppSize.s4),

                  // Price & Add to Cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Text(
                        "EGP ${price.toStringAsFixed(0)}",
                        style: getBoldStyle(
                          color: ColorManager.primary,
                          fontSize: FontSize.s12,
                        ),
                      ),

                      // Add to Cart Button
                      GestureDetector(
                        onTap: onAddToCartTap,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
