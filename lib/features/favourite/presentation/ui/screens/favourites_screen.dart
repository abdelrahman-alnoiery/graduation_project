import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/assets_manager.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_bloc.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_event.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_state.dart';

import '../../../../../core/utils/color_maanger.dart';
import '../../../../../core/utils/components/product_card.dart';
import '../../../../cart/presentation/bloc/cart_state.dart';
import '../../../../home/presentation/bloc/home_bloc.dart';
import '../../../../home/presentation/bloc/home_event.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FavouriteBloc>().add(const GetFavouritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // ── Header ──────────────────────────────
          Container(
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
                                  hintStyle: TextStyle(
                                    color: ColorManager.grey,
                                  ),
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
                              onTap: () => Navigator.pushNamed(
                                context,
                                Routes.cartRoute,
                              ),
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
          ),

          // ── Body ────────────────────────────────
          Expanded(
            child: BlocConsumer<FavouriteBloc, FavouriteState>(
              listener: (context, state) {
                if (state is FavouriteErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.failure.message),
                      backgroundColor: ColorManager.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is FavouriteLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.primary,
                    ),
                  );
                }

                if (state is FavouritesEmptyState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          ImageAssets.emptyFavorites,
                          height: AppSize.s200,
                        ),
                        const SizedBox(height: AppSize.s16),
                        Text(
                          "No Favourites Yet",
                          style: getBoldStyle(
                            color: ColorManager.textPrimary,
                            fontSize: FontSize.s20,
                          ),
                        ),
                        const SizedBox(height: AppSize.s8),
                        Text(
                          "Add products to your favourites",
                          style: getRegularStyle(
                            color: ColorManager.textSecondary,
                            fontSize: FontSize.s14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is GetFavouritesSuccessState) {
                  return Padding(
                    padding: const EdgeInsets.all(AppPadding.p16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Favorites",
                          style: getBoldStyle(
                            color: ColorManager.textPrimary,
                            fontSize: FontSize.s20,
                          ),
                        ),
                        const SizedBox(height: AppSize.s16),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: AppSize.s12,
                                  mainAxisSpacing: AppSize.s12,
                                  childAspectRatio: 0.75,
                                ),
                            itemCount: state.favourites.length,
                            itemBuilder: (context, index) {
                              final item = state.favourites[index];
                              return ProductCard(
                                productName: item.productName,
                                productImage: item.productImage,
                                price: item.price,
                                isFavorite: true,
                                onFavoriteTap: () {
                                  context.read<FavouriteBloc>().add(
                                    RemoveFavouriteEvent(item.productId),
                                  );
                                },
                                onCardTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.productDetails,
                                    arguments: item,
                                  );
                                },
                                onAddToCartTap: () {
                                  context.read<CartBloc>().add(
                                    AddCartItemEvent(
                                      productId: item.productId,
                                      productName: item.productName,
                                      productImage: item.productImage,
                                      price: item.price,
                                      quantity: 1,
                                    ),
                                  );
                                },
                              );
                            },
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
}
