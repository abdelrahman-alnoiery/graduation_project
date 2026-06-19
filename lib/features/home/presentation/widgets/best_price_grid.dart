import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/components/product_card.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';
import 'package:graduation_project/features/favourite/domain/entity/favourite_entity.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_bloc.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_event.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_state.dart';
import 'package:graduation_project/features/home/domain/entity/product_entity.dart';

class BestPriceGrid extends StatelessWidget {
  final List<ProductEntity> products;

  const BestPriceGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSize.s12,
        crossAxisSpacing: AppSize.s12,
        childAspectRatio: 0.75,
      ),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${product.name} added!"),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
