import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';

import '../../../../../core/utils/color_maanger.dart';
import '../../../../../core/utils/components/product_card.dart';
import '../../../../home/domain/entity/product_entity.dart';
import '../../../domain/entity/message_entity.dart';

class AiFixingResult extends StatelessWidget {
  final MessageEntity message;
  final List<ProductEntity> suggestedProducts;

  const AiFixingResult({
    super.key,
    required this.message,
    required this.suggestedProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Analyzed Image ───────────────────────
        if (message.imageUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            child: Stack(
              children: [
                Image.network(
                  message.imageUrl!,
                  width: double.infinity,
                  height: AppSize.s200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: AppSize.s200,
                    color: ColorManager.lightGrey,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: ColorManager.grey,
                      size: AppSize.s60,
                    ),
                  ),
                ),

                // ── AI Badge ──────────────────────
                Positioned(
                  bottom: AppSize.s8,
                  left: AppSize.s8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p8,
                      vertical: AppPadding.p4,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.primary.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.auto_fix_high,
                          color: ColorManager.white,
                          size: AppSize.s14,
                        ),
                        const SizedBox(width: AppSize.s4),
                        Text(
                          "AI Analyzed",
                          style: getMediumStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: AppSize.s12),

        // ── AI Result Message ────────────────────
        Container(
          padding: const EdgeInsets.all(AppPadding.p12),
          decoration: BoxDecoration(
            color: ColorManager.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(color: ColorManager.primary.withOpacity(0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.smart_toy_outlined,
                color: ColorManager.primary,
                size: AppSize.s20,
              ),
              const SizedBox(width: AppSize.s8),
              Expanded(
                child: Text(
                  message.content,
                  style: getRegularStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s14,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Suggested Products ───────────────────
        if (suggestedProducts.isNotEmpty) ...[
          const SizedBox(height: AppSize.s16),

          Text(
            "Suggested Products",
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s16,
            ),
          ),

          const SizedBox(height: AppSize.s12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSize.s12,
              mainAxisSpacing: AppSize.s12,
              childAspectRatio: 0.75,
            ),
            itemCount: suggestedProducts.length,
            itemBuilder: (context, index) {
              final product = suggestedProducts[index];
              return ProductCard(
                productName: product.name,
                productImage: product.image,
                price: product.price,
                isFavorite: product.isFavorite,
                onFavoriteTap: () {},
                onCardTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.productDetails,
                    arguments: product,
                  );
                },
                onAddToCartTap: () {
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
              );
            },
          ),
        ],
      ],
    );
  }
}
