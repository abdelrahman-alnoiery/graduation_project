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
import '../../../domain/entity/product_entity.dart';

class BestPriceSection extends StatelessWidget {
  final List<ProductEntity> products;

  const BestPriceSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p16,
            vertical: AppPadding.p12,
          ),
          child: Text(
            "Best Price",
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s16,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSize.s12,
            mainAxisSpacing: AppSize.s12,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
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
    );
  }
}
