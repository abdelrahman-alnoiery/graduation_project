import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_state.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_bloc.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_event.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_state.dart';
import 'package:graduation_project/features/products_screen/presentation/bloc/products_bloc.dart';
import 'package:graduation_project/features/products_screen/presentation/bloc/products_event.dart';
import 'package:graduation_project/features/products_screen/presentation/bloc/products_state.dart';

import '../../../../core/utils/color_maanger.dart';
import '../../../categories/domain/entity/category_entity.dart';
import '../../../favourite/domain/entity/favourite_entity.dart';

class ProductsScreen extends StatefulWidget {
  final CategoryEntity? category;
  const ProductsScreen({super.key, this.category});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(
      GetProductsEvent(categoryId: widget.category?.id),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // ── Header ────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(
              AppPadding.p16,
              AppPadding.p48,
              AppPadding.p16,
              AppPadding.p16,
            ),
            decoration: const BoxDecoration(
              color: ColorManager.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppRadius.r24),
                bottomRight: Radius.circular(AppRadius.r24),
              ),
            ),
            child: Column(
              children: [
                // ── Title Row ──────────────────────
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: ColorManager.white,
                        size: AppSize.s20,
                      ),
                    ),
                    const SizedBox(width: AppSize.s12),
                    Expanded(
                      child: Text(
                        widget.category?.name ?? "All Products",
                        style: getBoldStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s20,
                        ),
                      ),
                    ),
                    // ── Cart Icon ──────────────────
                    BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        int count = 0;
                        if (state is GetCartItemsSuccessState) {
                          count = state.cartItems.length;
                        }
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                context,
                                Routes.cartRoute,
                              ),
                              child: const Icon(
                                Icons.shopping_cart_outlined,
                                color: ColorManager.white,
                                size: AppSize.s28,
                              ),
                            ),
                            if (count > 0)
                              Positioned(
                                top: -AppSize.s4,
                                right: -AppSize.s4,
                                child: Container(
                                  width: AppSize.s16,
                                  height: AppSize.s16,
                                  decoration: const BoxDecoration(
                                    color: ColorManager.error,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "$count",
                                      style: const TextStyle(
                                        color: ColorManager.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: AppSize.s12),

                // ── Search Bar ─────────────────────
                Container(
                  height: AppSize.s44,
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    borderRadius: BorderRadius.circular(AppRadius.r50),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p12,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: ColorManager.grey),
                      const SizedBox(width: AppSize.s8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (query) {
                            context.read<ProductsBloc>().add(
                              GetProductsEvent(
                                categoryId: widget.category?.id,
                                searchQuery: query,
                              ),
                            );
                          },
                          decoration: InputDecoration(
                            hintText:
                                "Search in ${widget.category?.name ?? 'products'}...",
                            hintStyle: getRegularStyle(
                              color: ColorManager.grey,
                              fontSize: FontSize.s14,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Body ──────────────────────────────────
          Expanded(
            child: BlocBuilder<ProductsBloc, ProductsState>(
              builder: (context, state) {
                if (state is ProductsLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.primary,
                    ),
                  );
                }

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

                if (state is ProductsSuccessState) {
                  return RefreshIndicator(
                    color: ColorManager.primary,
                    onRefresh: () async {
                      context.read<ProductsBloc>().add(
                        GetProductsEvent(categoryId: widget.category?.id),
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
                                childAspectRatio: 0.72,
                              ),
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final product = state.products[index];
                            final isFav = favouriteIds.contains(product.id);

                            return GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                context,
                                Routes.productDetails,
                                arguments: product,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorManager.white,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.r16,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorManager.grey.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ── Image ───────
                                    Expanded(
                                      flex: 3,
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                  topLeft: Radius.circular(
                                                    AppRadius.r16,
                                                  ),
                                                  topRight: Radius.circular(
                                                    AppRadius.r16,
                                                  ),
                                                ),
                                            child: product.image.isNotEmpty
                                                ? Image.network(
                                                    product.image,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder:
                                                        (ctx, child, progress) {
                                                          if (progress == null)
                                                            return child;
                                                          return Container(
                                                            color: ColorManager
                                                                .lightGrey,
                                                            child: const Center(
                                                              child: CircularProgressIndicator(
                                                                color:
                                                                    ColorManager
                                                                        .primary,
                                                                strokeWidth: 2,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                    errorBuilder:
                                                        (_, __, ___) =>
                                                            _buildImageError(),
                                                  )
                                                : _buildImageError(),
                                          ),

                                          // ── Fav Button ──
                                          Positioned(
                                            top: AppSize.s8,
                                            right: AppSize.s8,
                                            child: GestureDetector(
                                              onTap: () {
                                                if (isFav) {
                                                  context
                                                      .read<FavouriteBloc>()
                                                      .add(
                                                        RemoveFavouriteEvent(
                                                          product.id,
                                                        ),
                                                      );
                                                } else {
                                                  context
                                                      .read<FavouriteBloc>()
                                                      .add(
                                                        AddFavouriteEvent(
                                                          FavouriteEntity(
                                                            id: product.id,
                                                            name: product.name,
                                                            image:
                                                                product.image,
                                                            price:
                                                                product.price,
                                                          ),
                                                        ),
                                                      );
                                                }
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  AppPadding.p4,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: ColorManager.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  isFav
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: isFav
                                                      ? ColorManager.error
                                                      : ColorManager.grey,
                                                  size: AppSize.s18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // ── Info ────────
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                          AppPadding.p8,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // ── Name ──
                                            Text(
                                              product.name,
                                              style: getMediumStyle(
                                                color: ColorManager.textPrimary,
                                                fontSize: FontSize.s12,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                            // ── Price Row ─
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "EGP ${product.price.toStringAsFixed(0)}",
                                                      style: getBoldStyle(
                                                        color: ColorManager
                                                            .primary,
                                                        fontSize: FontSize.s12,
                                                      ),
                                                    ),
                                                    if (product.oldPrice >
                                                        product.price)
                                                      Text(
                                                        "EGP ${product.oldPrice.toStringAsFixed(0)}",
                                                        style:
                                                            getRegularStyle(
                                                              color:
                                                                  ColorManager
                                                                      .grey,
                                                              fontSize:
                                                                  FontSize.s10,
                                                            ).copyWith(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                            ),
                                                      ),
                                                  ],
                                                ),

                                                // ── Add to Cart ─
                                                GestureDetector(
                                                  onTap: () {
                                                    context
                                                        .read<CartBloc>()
                                                        .add(
                                                          AddCartItemEvent(
                                                            productId:
                                                                product.id,
                                                            productName:
                                                                product.name,
                                                            productImage:
                                                                product.image,
                                                            price:
                                                                product.price,
                                                            quantity: 1,
                                                          ),
                                                        );
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          "${product.name} added!",
                                                        ),
                                                        backgroundColor:
                                                            ColorManager
                                                                .success,
                                                        duration:
                                                            const Duration(
                                                              seconds: 1,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          AppPadding.p6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          ColorManager.primary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            AppRadius.r8,
                                                          ),
                                                    ),
                                                    child: const Icon(
                                                      Icons
                                                          .shopping_cart_outlined,
                                                      color: ColorManager.white,
                                                      size: AppSize.s16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // ── Rating ────
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: AppSize.s12,
                                                ),
                                                const SizedBox(
                                                  width: AppSize.s4,
                                                ),
                                                Text(
                                                  "${product.rating.toStringAsFixed(1)} (${product.reviewCount})",
                                                  style: getRegularStyle(
                                                    color: ColorManager
                                                        .textSecondary,
                                                    fontSize: FontSize.s10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }

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
                            GetProductsEvent(categoryId: widget.category?.id),
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
          ),
        ],
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      color: ColorManager.lightGrey,
      child: const Center(
        child: Icon(
          Icons.directions_car,
          color: ColorManager.primary,
          size: AppSize.s40,
        ),
      ),
    );
  }
}
