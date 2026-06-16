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
import '../../domain/entity/category_entity.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  // ── Category Colors ───────────────────────────────
  List<Color> get _categoryColors => [
    const Color(0xFF1a237e),
    const Color(0xFF3949ab),
    const Color(0xFF0d47a1),
    const Color(0xFF1976d2),
    const Color(0xFF006064),
    const Color(0xFF00838f),
    const Color(0xFF1b5e20),
    const Color(0xFF388e3c),
    const Color(0xFF4a148c),
    const Color(0xFF7b1fa2),
    const Color(0xFFb71c1c),
    const Color(0xFFe53935),
    const Color(0xFFe65100),
    const Color(0xFFf57c00),
    const Color(0xFF006064),
    const Color(0xFF0097a7),
  ];

  // ── Category Icons ────────────────────────────────
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
              AppPadding.p20,
              AppPadding.p52,
              AppPadding.p20,
              AppPadding.p24,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppRadius.r32),
                bottomRight: Radius.circular(AppRadius.r32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x441a237e),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Row ───────────────────────────────
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppPadding.p10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                      child: const Icon(
                        Icons.grid_view_rounded,
                        color: Colors.white,
                        size: AppSize.s24,
                      ),
                    ),
                    const SizedBox(width: AppSize.s12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Categories",
                          style: getBoldStyle(
                            color: Colors.white,
                            fontSize: FontSize.s22,
                          ),
                        ),
                        Text(
                          "Find your car parts",
                          style: getRegularStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: FontSize.s13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: AppSize.s16),

                // ── Decorative Chips ──────────────────────
                SingleChildScrollView(scrollDirection: Axis.horizontal),
              ],
            ),
          ),

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
                      final color =
                          _categoryColors[index % _categoryColors.length];
                      return _buildCategoryCard(
                        context,
                        category: category,
                        color: color,
                        index: index,
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

  // ── Category Card ─────────────────────────────────
  Widget _buildCategoryCard(
    BuildContext context, {
    required CategoryEntity category,
    required Color color,
    required int index,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.productsScreenRoute,
        arguments: category,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(AppRadius.r20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // ── Background Pattern ─────────────────
            Positioned(
              right: -AppSize.s16,
              bottom: -AppSize.s16,
              child: Icon(
                _getCategoryIcon(category.icon),
                size: AppSize.s100,
                color: ColorManager.white.withOpacity(0.1),
              ),
            ),

            // ── Content ────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppPadding.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ── Icon Box ──────────────────────
                  Container(
                    padding: const EdgeInsets.all(AppPadding.p10),
                    decoration: BoxDecoration(
                      color: ColorManager.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                    ),
                    child: Icon(
                      _getCategoryIcon(category.icon),
                      color: ColorManager.white,
                      size: AppSize.s28,
                    ),
                  ),

                  // ── Name & Arrow ──────────────────
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: getBoldStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSize.s4),
                      Row(
                        children: [
                          Text(
                            "Explore",
                            style: getRegularStyle(
                              color: ColorManager.white.withOpacity(0.8),
                              fontSize: FontSize.s12,
                            ),
                          ),
                          const SizedBox(width: AppSize.s4),
                          Icon(
                            Icons.arrow_forward,
                            color: ColorManager.white.withOpacity(0.8),
                            size: AppSize.s12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
