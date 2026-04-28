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
          // ── Header ──────────────────────────────
          _buildHeader(context),

          // ── Body ────────────────────────────────
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
                if (state is HomeLoadingState || state is SearchLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.primary,
                    ),
                  );
                }

                if (state is SearchEmptyState) {
                  return Center(
                    child: Text(
                      "No products found",
                      style: getMediumStyle(
                        color: ColorManager.textSecondary,
                        fontSize: FontSize.s16,
                      ),
                    ),
                  );
                }

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
                  );
                }

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
                              fontSize: FontSize.s20,
                            ),
                          ),
                          const SizedBox(height: AppSize.s12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: state.brands
                                .map(
                                  (brand) => _BrandItem(
                                    name: brand.name,
                                    image: brand.image,
                                  ),
                                )
                                .toList(),
                          ),

                          const SizedBox(height: AppSize.s20),

                          // ── Trends ───────────────
                          Text(
                            "Trends",
                            style: getBoldStyle(
                              color: ColorManager.textPrimary,
                              fontSize: FontSize.s20,
                            ),
                          ),
                          const SizedBox(height: AppSize.s12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.r16),
                            child: Image.network(
                              state.trends.isNotEmpty
                                  ? state.trends.first.image
                                  : "https://images.unsplash.com/photo-1492144534655-ae79c964c9d7",
                              height: AppSize.s150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(height: AppSize.s20),

                          // ── Best Price ────────────
                          Text(
                            "Best Price",
                            style: getBoldStyle(
                              color: ColorManager.textPrimary,
                              fontSize: FontSize.s20,
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

                          const SizedBox(height: AppSize.s20),
                        ],
                      ),
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

  // ── Header ────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p16),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: ColorManager.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.r24),
          bottomRight: Radius.circular(AppRadius.r24),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: AppSize.s40),

          // ── Logo ──────────────────────────────
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

          // ── Search & Cart ─────────────────────
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
                          onChanged: (query) {
                            context.read<HomeBloc>().add(
                              SearchProductsEvent(query),
                            );
                          },
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

              // ── Cart Icon with Badge ───────────
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
          const SizedBox(height: AppSize.s8),
        ],
      ),
    );
  }
}

// ── Brand Item ────────────────────────────────────────
class _BrandItem extends StatelessWidget {
  final String name;
  final String image;

  const _BrandItem({required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: AppSize.s60,
          width: AppSize.s60,
          decoration: BoxDecoration(
            color: ColorManager.white,
            shape: BoxShape.circle,
            border: Border.all(color: ColorManager.lightGrey),
          ),
          child: ClipOval(
            child: Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.directions_car, color: ColorManager.primary),
            ),
          ),
        ),
        const SizedBox(height: AppSize.s4),
        Text(
          name,
          style: getRegularStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s12,
          ),
        ),
      ],
    );
  }
}
