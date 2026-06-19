import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/color_maanger.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppPadding.p6),
          decoration: BoxDecoration(
            color: const Color(0xFF1a237e).withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.r8),
          ),
          child: Icon(icon, color: const Color(0xFF1a237e), size: AppSize.s18),
        ),
        const SizedBox(width: AppSize.s10),
        Text(
          title,
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s18,
          ),
        ),
      ],
    );
  }
}
