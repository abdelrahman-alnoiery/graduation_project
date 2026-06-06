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

import '../../../../../core/utils/color_maanger.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // ── Header ────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              AppPadding.p16,
              AppPadding.p48,
              AppPadding.p16,
              AppPadding.p20,
            ),
            decoration: const BoxDecoration(
              color: ColorManager.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppRadius.r24),
                bottomRight: Radius.circular(AppRadius.r24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const Icon(
                //   Icons.favorite,
                //   color: ColorManager.white,
                //   size: AppSize.s28,
                // ),
                // const SizedBox(width: AppSize.s12),
                Center(
                  child: Text(
                    "My Favourites",
                    style: getBoldStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s24,
                    ),
                  ),
                ),
                const Spacer(),
                // ── Item Count ────────────────────
                BlocBuilder<FavouriteBloc, FavouriteState>(
                  builder: (context, state) {
                    final count = state is FavouriteSuccessState
                        ? state.favourites.length
                        : 0;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.p12,
                        vertical: AppPadding.p4,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManager.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppRadius.r50),
                      ),
                      child: Text(
                        "$count items",
                        style: getMediumStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // ── Body ──────────────────────────────────
          Expanded(
            child: BlocBuilder<FavouriteBloc, FavouriteState>(
              builder: (context, state) {
                // ── Loading ───────────────────────
                if (state is FavouriteLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.primary,
                    ),
                  );
                }

                // ── Empty ─────────────────────────
                if (state is FavouriteEmptyState ||
                    state is FavouriteInitialState) {
                  return _buildEmpty(context);
                }

                // ── Success ───────────────────────
                if (state is FavouriteSuccessState) {
                  return Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(AppPadding.p16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: AppSize.s12,
                                crossAxisSpacing: AppSize.s12,
                                childAspectRatio: 0.72,
                              ),
                          itemCount: state.favourites.length,
                          itemBuilder: (context, index) {
                            final item = state.favourites[index];
                            return _buildFavCard(context, item);
                          },
                        ),
                      ),
                    ],
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

  // ── Favourite Card ────────────────────────────────
  Widget _buildFavCard(BuildContext context, item) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, Routes.productDetails, arguments: item),
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.r16),
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
            // ── Image ─────────────────────────────
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.r16),
                      topRight: Radius.circular(AppRadius.r16),
                    ),
                    child: item.image.isNotEmpty
                        ? Image.network(
                            item.image,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (ctx, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: ColorManager.lightGrey,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: ColorManager.primary,
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => _buildImageError(),
                          )
                        : _buildImageError(),
                  ),

                  // ── Remove Button ─────────────
                  Positioned(
                    top: AppSize.s8,
                    right: AppSize.s8,
                    child: GestureDetector(
                      onTap: () {
                        context.read<FavouriteBloc>().add(
                          RemoveFavouriteEvent(item.id),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppPadding.p4),
                        decoration: const BoxDecoration(
                          color: ColorManager.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: ColorManager.error,
                          size: AppSize.s18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info ──────────────────────────────
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.p8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ── Name ──────────────────────
                    Text(
                      item.name,
                      style: getMediumStyle(
                        color: ColorManager.textPrimary,
                        fontSize: FontSize.s12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // ── Price & Cart ───────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "EGP ${item.price.toStringAsFixed(0)}",
                          style: getBoldStyle(
                            color: ColorManager.primary,
                            fontSize: FontSize.s13,
                          ),
                        ),

                        // ── Add to Cart ───────────
                        GestureDetector(
                          onTap: () {
                            context.read<CartBloc>().add(
                              AddCartItemEvent(
                                productId: item.id,
                                productName: item.name,
                                productImage: item.image,
                                price: item.price,
                                quantity: 1,
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${item.name} added to cart!"),
                                backgroundColor: ColorManager.success,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(AppPadding.p6),
                            decoration: BoxDecoration(
                              color: ColorManager.primary,
                              borderRadius: BorderRadius.circular(AppRadius.r8),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart_outlined,
                              color: ColorManager.white,
                              size: AppSize.s16,
                            ),
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
  }

  // ── Empty State ───────────────────────────────────
  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Animated Icon ──────────────────────
          Container(
            width: AppSize.s120,
            height: AppSize.s120,
            decoration: BoxDecoration(
              color: ColorManager.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border,
              color: ColorManager.primary,
              size: AppSize.s60,
            ),
          ),

          const SizedBox(height: AppSize.s24),

          Text(
            "No Favourites Yet!",
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s22,
            ),
          ),

          const SizedBox(height: AppSize.s8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p32),
            child: Text(
              "Start adding products you love\nto your favourites list",
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s14,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppSize.s32),

          // ── Browse Button ──────────────────────
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.homePageLayoutRoute,
              (route) => false,
            ),
            icon: const Icon(Icons.explore_outlined, color: ColorManager.white),
            label: Text(
              "Browse Products",
              style: getBoldStyle(
                color: ColorManager.white,
                fontSize: FontSize.s16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p32,
                vertical: AppPadding.p16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.r50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Image Error ───────────────────────────────────
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
