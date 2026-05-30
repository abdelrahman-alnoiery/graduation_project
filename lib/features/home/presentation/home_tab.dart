import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_state.dart';
import 'package:graduation_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:graduation_project/features/home/presentation/bloc/home_event.dart';
import 'package:graduation_project/features/home/presentation/bloc/home_state.dart';

import '../../../core/utils/color_maanger.dart';
import '../../../core/utils/components/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

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
          _buildHeader(context),

          // ── Body ──────────────────────────────────
          Expanded(
            child: BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is HomeDataErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.failure.message),
                      backgroundColor: ColorManager.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                // ── Loading ────────────────────────
                if (state is HomeLoadingState || state is SearchLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.primary,
                    ),
                  );
                }

                // ── Search Empty ───────────────────
                if (state is SearchEmptyState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: ColorManager.grey,
                        ),
                        const SizedBox(height: AppSize.s12),
                        Text(
                          "No products found",
                          style: getMediumStyle(
                            color: ColorManager.textSecondary,
                            fontSize: FontSize.s16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // ── Search Results ─────────────────
                if (state is SearchSuccessState) {
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
                      return ProductCard(
                        productName: product.name,
                        productImage: product.image,
                        price: product.price,
                        isFavorite: product.isFavorite,
                        onFavoriteTap: () {},
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
                }

                // ── Home Data ──────────────────────
                if (state is HomeDataSuccessState) {
                  return RefreshIndicator(
                    color: ColorManager.primary,
                    onRefresh: () async {
                      context.read<HomeBloc>().add(const GetHomeDataEvent());
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(AppPadding.p16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Global Company ───────
                          Text(
                            "Global Company",
                            style: getBoldStyle(
                              color: ColorManager.textPrimary,
                              fontSize: FontSize.s18,
                            ),
                          ),
                          const SizedBox(height: AppSize.s12),

                          // ── Brands Row ───────────
                          SizedBox(
                            height: AppSize.s80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.brands.length,
                              itemBuilder: (context, index) {
                                final brand = state.brands[index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    right: AppPadding.p16,
                                  ),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: AppSize.s28,
                                        backgroundColor: ColorManager.primary
                                            .withOpacity(0.1),
                                        child: const Icon(
                                          Icons.directions_car,
                                          color: ColorManager.primary,
                                          size: AppSize.s20,
                                        ),
                                      ),
                                      const SizedBox(height: AppSize.s4),
                                      Text(
                                        brand.name,
                                        style: getRegularStyle(
                                          color: ColorManager.textPrimary,
                                          fontSize: FontSize.s12,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: AppSize.s20),

                          // ── Trends ────────────────
                          Text(
                            "Trends",
                            style: getBoldStyle(
                              color: ColorManager.textPrimary,
                              fontSize: FontSize.s18,
                            ),
                          ),
                          const SizedBox(height: AppSize.s12),

                          // في الـ Trends section
                          SizedBox(
                            height: AppSize.s150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.trends.length,
                              itemBuilder: (context, index) {
                                final trend = state.trends[index];
                                return GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    Routes.productDetails,
                                    arguments: trend,
                                  ),
                                  child: Container(
                                    width: AppSize.s200,
                                    margin: const EdgeInsets.only(
                                      right: AppPadding.p12,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.r12,
                                      ),
                                      color: ColorManager.lightGrey,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.r12,
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          // ── Image ──────────────────────
                                          Image.network(
                                            trend.image,
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (
                                                  context,
                                                  child,
                                                  loadingProgress,
                                                ) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: ColorManager
                                                              .primary,
                                                          strokeWidth: 2,
                                                        ),
                                                  );
                                                },
                                            errorBuilder: (_, __, ___) => Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.directions_car,
                                                  color: ColorManager.primary,
                                                  size: AppSize.s32,
                                                ),
                                                const SizedBox(
                                                  height: AppSize.s4,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal:
                                                            AppPadding.p8,
                                                      ),
                                                  child: Text(
                                                    trend.name,
                                                    style: getRegularStyle(
                                                      color: ColorManager
                                                          .textPrimary,
                                                      fontSize: FontSize.s10,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // ── Name Overlay ──────────────
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(
                                                AppPadding.p8,
                                              ),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Colors.black.withOpacity(
                                                      0.7,
                                                    ),
                                                    Colors.transparent,
                                                  ],
                                                ),
                                              ),
                                              child: Text(
                                                trend.name,
                                                style: getMediumStyle(
                                                  color: ColorManager.white,
                                                  fontSize: FontSize.s12,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: AppSize.s20),

                          // ── Best Price ────────────
                          Text(
                            "Best Price",
                            style: getBoldStyle(
                              color: ColorManager.textPrimary,
                              fontSize: FontSize.s18,
                            ),
                          ),
                          const SizedBox(height: AppSize.s12),

                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.bestPriceProducts.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: AppSize.s12,
                                  crossAxisSpacing: AppSize.s12,
                                  childAspectRatio: 0.75,
                                ),
                            itemBuilder: (context, index) {
                              final product = state.bestPriceProducts[index];
                              return ProductCard(
                                productName: product.name,
                                productImage: product.image,
                                price: product.price,
                                isFavorite: product.isFavorite,
                                onFavoriteTap: () {},
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
                          ),

                          const SizedBox(height: AppSize.s20),
                        ],
                      ),
                    ),
                  );
                }

                // ── Error ──────────────────────────
                if (state is HomeDataErrorState) {
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
                          state.failure.message,
                          style: getRegularStyle(
                            color: ColorManager.error,
                            fontSize: FontSize.s14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSize.s16),
                        ElevatedButton(
                          onPressed: () => context.read<HomeBloc>().add(
                            const GetHomeDataEvent(),
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

  // ── Header ───────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
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
          // ── Logo ──────────────────────────────────
          Text(
            "CarGo",
            style: GoogleFonts.mali(
              fontSize: 44,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: AppSize.s12),

          // ── Search + Cart ─────────────────────────
          Row(
            children: [
              Expanded(
                child: Container(
                  height: AppSize.s48,
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
                          onChanged: (query) => context.read<HomeBloc>().add(
                            SearchProductsEvent(query),
                          ),
                          decoration: const InputDecoration(
                            hintText: "Search...",
                            hintStyle: TextStyle(color: ColorManager.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: AppSize.s12),

              // ── Cart Icon ────────────────────────
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  int itemCount = 0;
                  if (state is GetCartItemsSuccessState) {
                    itemCount = state.cartItems.length;
                  }
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, Routes.cartRoute),
                        child: Container(
                          height: AppSize.s48,
                          width: AppSize.s48,
                          decoration: const BoxDecoration(
                            color: ColorManager.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            color: ColorManager.primary,
                          ),
                        ),
                      ),
                      if (itemCount > 0)
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
                                itemCount > 9 ? "9+" : "$itemCount",
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
        ],
      ),
    );
  }

  // ── Image Error ──────────────────────────────────
  Widget _buildImageError() {
    return Container(
      width: AppSize.s200,
      height: AppSize.s150,
      color: ColorManager.lightGrey,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: ColorManager.grey,
      ),
    );
  }
}
