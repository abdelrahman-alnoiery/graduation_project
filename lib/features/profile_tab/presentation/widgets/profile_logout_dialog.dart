import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/utils/color_maanger.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_bloc.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_event.dart';

void showProfileLogoutDialog(BuildContext context) {
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
              padding: const EdgeInsets.all(AppPadding.p16),
              decoration: BoxDecoration(
                color: const Color(0xFFb71c1c).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFb71c1c),
                size: AppSize.s32,
              ),
            ),

            const SizedBox(height: AppSize.s16),

            Text(
              "Logout",
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s20,
              ),
            ),

            const SizedBox(height: AppSize.s8),

            Text(
              "Are you sure you want to\nlogout from your account?",
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s14,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSize.s24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppPadding.p14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: getMediumStyle(
                        color: ColorManager.textSecondary,
                        fontSize: FontSize.s14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSize.s12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.read<ProfileBloc>().add(const LogoutEvent());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFb71c1c),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppPadding.p14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Logout",
                      style: getBoldStyle(
                        color: Colors.white,
                        fontSize: FontSize.s14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
