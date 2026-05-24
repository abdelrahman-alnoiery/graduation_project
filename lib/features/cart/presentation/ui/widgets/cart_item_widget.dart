import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

import '../../../../../core/utils/color_maanger.dart';
import '../../../../../core/utils/components/product_counter.dart';
import '../../../domain/entity/cart_item_entity.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p12),
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
      child: Row(
        children: [
          // ── Product Image ──────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.r8),
            child: Image.network(
              item.image,
              width: AppSize.s80,
              height: AppSize.s80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: AppSize.s80,
                height: AppSize.s80,
                color: ColorManager.lightGrey,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: ColorManager.grey,
                ),
              ),
            ),
          ),

          const SizedBox(width: AppSize.s12),

          // ── Product Info ───────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  item.name,
                  style: getMediumStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: AppSize.s8),

                // Price
                Text(
                  "EGP ${item.price.toStringAsFixed(0)}",
                  style: getBoldStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s14,
                  ),
                ),

                const SizedBox(height: AppSize.s8),

                // Counter & Remove
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ProductCounter(
                      count: item.quantity,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(
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
        ],
      ),
    );
  }
}
