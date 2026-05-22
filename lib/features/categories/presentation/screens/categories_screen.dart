import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:graduation_project/features/categories/presentation/bloc/categories_event.dart';
import 'package:graduation_project/features/categories/presentation/bloc/categories_state.dart';

import '../../../../core/utils/color_maanger.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  // ── Icon للكل Category ────────────────────────────
  IconData _getCategoryIcon(String icon) {
    switch (icon) {
      case 'engine':
        return Icons.settings;
      case 'body':
        return Icons.directions_car;
      case 'electrical':
        return Icons.electrical_services;
      case 'brakes':
        return Icons.radio_button_checked;
      case 'suspension':
        return Icons.car_repair;
      case 'tires':
        return Icons.tire_repair;
      case 'interior':
        return Icons.chair;
      case 'accessories':
        return Icons.add_shopping_cart;
      default:
        return Icons.category;
    }
  }

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
                "Categories",
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
            child: BlocBuilder<CategoriesBloc, CategoriesState>(
              builder: (context, state) {
                if (state is CategoriesLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.primary,
                    ),
                  );
                }

                if (state is CategoriesSuccessState) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(AppPadding.p16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppSize.s12,
                          crossAxisSpacing: AppSize.s12,
                          childAspectRatio: 1.1,
                        ),
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          Routes.productsScreenRoute,
                          arguments: category,
                        ),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ── Icon ──────────────
                              Container(
                                padding: const EdgeInsets.all(AppPadding.p16),
                                decoration: BoxDecoration(
                                  color: ColorManager.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getCategoryIcon(category.icon),
                                  color: ColorManager.primary,
                                  size: AppSize.s32,
                                ),
                              ),

                              const SizedBox(height: AppSize.s12),

                              // ── Name ──────────────
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppPadding.p8,
                                ),
                                child: Text(
                                  category.name,
                                  style: getMediumStyle(
                                    color: ColorManager.textPrimary,
                                    fontSize: FontSize.s14,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                if (state is CategoriesErrorState) {
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
                          onPressed: () => context.read<CategoriesBloc>().add(
                            const GetCategoriesEvent(),
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
}
