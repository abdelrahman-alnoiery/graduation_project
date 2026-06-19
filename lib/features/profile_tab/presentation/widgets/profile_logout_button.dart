import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

class ProfileLogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileLogoutButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppPadding.p16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFb71c1c), Color(0xFFe53935)],
          ),
          borderRadius: BorderRadius.circular(AppRadius.r16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFb71c1c).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout_rounded,
              color: Colors.white,
              size: AppSize.s20,
            ),
            const SizedBox(width: AppSize.s8),
            Text(
              "Logout",
              style: getBoldStyle(color: Colors.white, fontSize: FontSize.s16),
            ),
          ],
        ),
      ),
    );
  }
}
