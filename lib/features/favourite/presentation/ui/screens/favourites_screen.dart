import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
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
            child: Center(
              child: Text(
                "Favourites",
                style: getBoldStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s24,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSize.s16),

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
                if (state is FavouriteEmptyState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.favorite_border,
                          color: ColorManager.grey,
                          size: AppSize.s80,
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
                          "Add products to your favourites\nto see them here",
                          style: getRegularStyle(
                            color: ColorManager.textSecondary,
                            fontSize: FontSize.s14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // ── Success ───────────────────────
                if (state is FavouriteSuccessState) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(AppPadding.p16),
                    itemCount: state.favourites.length,
                    itemBuilder: (context, index) {
                      final item = state.favourites[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppMargin.m12),
                        decoration: BoxDecoration(
                          color: ColorManager.white,
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                          boxShadow: [
                            BoxShadow(
                              color: ColorManager.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(AppPadding.p12),
                          // ── Image ───────────────
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.r8),
                            child: item.image.isNotEmpty
                                ? Image.network(
                                    item.image,
                                    width: AppSize.s64,
                                    height: AppSize.s64,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _buildImageError(),
                                  )
                                : _buildImageError(),
                          ),

                          // ── Info ────────────────
                          title: Text(
                            item.name,
                            style: getMediumStyle(
                              color: ColorManager.textPrimary,
                              fontSize: FontSize.s14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            "EGP ${item.price.toStringAsFixed(0)}",
                            style: getBoldStyle(
                              color: ColorManager.primary,
                              fontSize: FontSize.s14,
                            ),
                          ),

                          // ── Remove ──────────────
                          trailing: IconButton(
                            onPressed: () {
                              context.read<FavouriteBloc>().add(
                                RemoveFavouriteEvent(item.id),
                              );
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: ColorManager.error,
                            ),
                          ),

                          onTap: () => Navigator.pushNamed(
                            context,
                            Routes.productDetails,
                            arguments: item,
                          ),
                        ),
                      );
                    },
                  );
                }

                // ── Error ─────────────────────────
                if (state is FavouriteErrorState) {
                  return Center(
                    child: Text(
                      state.message,
                      style: getRegularStyle(
                        color: ColorManager.error,
                        fontSize: FontSize.s14,
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

  Widget _buildImageError() {
    return Container(
      width: AppSize.s64,
      height: AppSize.s64,
      color: ColorManager.lightGrey,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: ColorManager.grey,
      ),
    );
  }
}
