import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/color_maanger.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

void showProfileAboutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r24),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSize.s80,
              height: AppSize.s80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
                ),
                borderRadius: BorderRadius.circular(AppRadius.r20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1a237e).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.directions_car_rounded,
                  color: Colors.white,
                  size: AppSize.s40,
                ),
              ),
            ),

            const SizedBox(height: AppSize.s16),

            Text(
              "CarGo",
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s24,
              ),
            ),

            const SizedBox(height: AppSize.s4),

            Text(
              "Version 1.0.0",
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s13,
              ),
            ),

            const SizedBox(height: AppSize.s16),

            Container(
              padding: const EdgeInsets.all(AppPadding.p16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F8),
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: Text(
                "CarGo is your one-stop shop for car accessories and parts. Find everything you need for your vehicle at the best prices.",
                style: getRegularStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s13,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: AppSize.s20),

            _AboutRow(icon: Icons.code_rounded, text: "Developed by CarGo Team"),
            const SizedBox(height: AppSize.s8),
            _AboutRow(icon: Icons.school_rounded, text: "Graduation Project 2026"),

            const SizedBox(height: AppSize.s24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1a237e),
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.p14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Close",
                  style: getBoldStyle(color: Colors.white, fontSize: FontSize.s14),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _AboutRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _AboutRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF1a237e), size: AppSize.s16),
        const SizedBox(width: AppSize.s8),
        Text(
          text,
          style: getMediumStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s13,
          ),
        ),
      ],
    );
  }
}
