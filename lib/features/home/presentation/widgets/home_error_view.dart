import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/color_maanger.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

class HomeErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const HomeErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppPadding.p24),
            decoration: BoxDecoration(
              color: ColorManager.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              color: ColorManager.error,
              size: AppSize.s48,
            ),
          ),
          const SizedBox(height: AppSize.s16),
          Text(
            "Oops! Something went wrong",
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s18,
            ),
          ),
          const SizedBox(height: AppSize.s8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p32),
            child: Text(
              message,
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s13,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSize.s24),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p32,
                vertical: AppPadding.p14,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
                ),
                borderRadius: BorderRadius.circular(AppRadius.r50),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1a237e).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: AppSize.s20,
                  ),
                  const SizedBox(width: AppSize.s8),
                  Text(
                    "Try Again",
                    style: getBoldStyle(
                      color: Colors.white,
                      fontSize: FontSize.s15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
