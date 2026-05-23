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
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_state.dart';
import 'package:graduation_project/features/products_screen/presentation/bloc/products_bloc.dart';
import 'package:graduation_project/features/products_screen/presentation/bloc/products_event.dart'
    hide GetProductsEvent;
import 'package:graduation_project/features/products_screen/presentation/bloc/products_state.dart';

import '../../../../core/utils/color_maanger.dart';
import '../../../../core/utils/components/product_card.dart';
import '../../../categories/domain/entity/category_entity.dart';
import '../../../favourite/domain/entity/favourite_entity.dart';
import '../../../home/presentation/bloc/home_event.dart';

class ProductsScreen extends StatefulWidget {
  final CategoryEntity? category;
  const ProductsScreen({super.key, this.category});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(
      GetProductsEvent(categoryId: widget.category?.id) as ProductsEvent,
    );
  }

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
          widget.category?.name ?? "All Products",
          style: getBoldStyle(
            color: ColorManager.white,
            fontSize: FontSize.s18,
          ),
        ),
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          // ── Loading ───────────────────────────────
          if (state is ProductsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: ColorManager.primary),
            );
          }

          // ── Empty ─────────────────────────────────
          if (state is ProductsEmptyState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    color: ColorManager.grey,
                    size: AppSize.s80,
                  ),
                  const SizedBox(height: AppSize.s16),
                  Text(
                    "No Products Found",
                    style: getBoldStyle(
                      color: ColorManager.textPrimary,
                      fontSize: FontSize.s20,
                    ),
                  ),
                  const SizedBox(height: AppSize.s8),
                  Text(
                    "No products available in this category",
                    style: getRegularStyle(
                      color: ColorManager.textSecondary,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ],
              ),
            );
          }

          // ── Success ───────────────────────────────
          if (state is ProductsSuccessState) {
            return RefreshIndicator(
              color: ColorManager.primary,
              onRefresh: () async {
                context.read<ProductsBloc>().add(
                  GetProductsEvent(categoryId: widget.category?.id)
                      as ProductsEvent,
                );
              },
              child: BlocBuilder<FavouriteBloc, FavouriteState>(
                builder: (context, favState) {
                  final favouriteIds = favState is FavouriteSuccessState
                      ? favState.favourites.map((f) => f.id).toSet()
                      : <String>{};

                  return GridView.builder(
                    padding: const EdgeInsets.all(AppPadding.p16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppSize.s12,
                          crossAxisSpacing: AppSize.s12,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      final isFav = favouriteIds.contains(product.id);

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
                              content: Text("${product.name} added to cart!"),
                              backgroundColor: ColorManager.success,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            );
          }

          // ── Error ─────────────────────────────────
          if (state is ProductsErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: ColorManager.error,
                    size: AppSize.s60,
                  ),
                  const SizedBox(height: AppSize.s12),
                  Text(
                    state.message,
                    style: getRegularStyle(
                      color: ColorManager.error,
                      fontSize: FontSize.s14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSize.s16),
                  ElevatedButton(
                    onPressed: () => context.read<ProductsBloc>().add(
                      GetProductsEvent(categoryId: widget.category?.id)
                          as ProductsEvent,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary,
                    ),
                    child: const Text(
                      "Retry",
                      style: TextStyle(color: ColorManager.white),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
