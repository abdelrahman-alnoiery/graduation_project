import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

import '../../../../../core/utils/color_maanger.dart';

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p12),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          border: Border.all(color: ColorManager.lightGrey),
          boxShadow: [
            BoxShadow(
              color: ColorManager.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Icon ────────────────────────────
            Container(
              padding: const EdgeInsets.all(AppPadding.p8),
              decoration: BoxDecoration(
                color: ColorManager.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.r8),
              ),
              child: Icon(icon, color: ColorManager.primary, size: AppSize.s24),
            ),

            const SizedBox(width: AppSize.s12),

            // ── Title & Subtitle ─────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getMediumStyle(
                      color: ColorManager.textPrimary,
                      fontSize: FontSize.s14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: getRegularStyle(
                      color: ColorManager.textSecondary,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ],
              ),
            ),

            // ── Arrow ────────────────────────────
            const Icon(
              Icons.arrow_forward_ios,
              color: ColorManager.grey,
              size: AppSize.s16,
            ),
          ],
        ),
      ),
    );
  }
}
