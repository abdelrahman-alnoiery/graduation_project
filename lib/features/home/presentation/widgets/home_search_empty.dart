import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/color_maanger.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

class HomeSearchEmpty extends StatelessWidget {
  const HomeSearchEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppPadding.p24),
            decoration: BoxDecoration(
              color: const Color(0xFF1a237e).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: AppSize.s60,
              color: const Color(0xFF1a237e).withOpacity(0.4),
            ),
          ),
          const SizedBox(height: AppSize.s20),
          Text(
            "No products found",
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s20,
            ),
          ),
          const SizedBox(height: AppSize.s8),
          Text(
            "Try a different search term",
            style: getRegularStyle(
              color: ColorManager.textSecondary,
              fontSize: FontSize.s14,
            ),
          ),
        ],
      ),
    );
  }
}
