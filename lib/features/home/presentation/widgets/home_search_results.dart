import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/color_maanger.dart';
import 'package:graduation_project/core/utils/components/product_card.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';
import 'package:graduation_project/features/favourite/domain/entity/favourite_entity.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_bloc.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_event.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_state.dart';
import 'package:graduation_project/features/home/domain/entity/product_entity.dart';

class HomeSearchResults extends StatelessWidget {
  final List<ProductEntity> products;

  const HomeSearchResults({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppPadding.p16,
            AppPadding.p16,
            AppPadding.p16,
            AppPadding.p8,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search_rounded,
                color: Color(0xFF1a237e),
                size: AppSize.s18,
              ),
              const SizedBox(width: AppSize.s8),
              Text(
                "${products.length} results found",
                style: getMediumStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s14,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSize.s12,
              crossAxisSpacing: AppSize.s12,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return BlocBuilder<FavouriteBloc, FavouriteState>(
                builder: (context, favState) {
                  final isFav =
                      favState is FavouriteSuccessState &&
                      favState.favourites.any((f) => f.id == product.id);
                  return ProductCard(
                    productName: product.name,
                    productImage: product.image,
                    price: product.price,
                    isFavorite: isFav,
                    onFavoriteTap: () {
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
                    onCardTap: () => Navigator.pushNamed(
                      context,
                      Routes.productDetails,
                      arguments: product,
                    ),
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
              );
            },
          ),
        ),
      ],
    );
  }
}
