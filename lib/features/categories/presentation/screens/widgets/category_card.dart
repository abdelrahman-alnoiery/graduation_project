import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

import '../../../../../core/utils/color_maanger.dart';
import '../../../domain/entity/category_entity.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          boxShadow: [
            BoxShadow(
              color: ColorManager.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Category Image ─────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.r8),
              child: Image.network(
                category.image,
                height: AppSize.s80,
                width: AppSize.s80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.category_outlined,
                  color: ColorManager.primary,
                  size: AppSize.s40,
                ),
              ),
            ),

            const SizedBox(height: AppSize.s8),

            // ── Category Name ──────────────────
            Text(
              category.name,
              style: getMediumStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s14,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
