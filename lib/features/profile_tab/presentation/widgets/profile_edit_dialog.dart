import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/utils/color_maanger.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_bloc.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_event.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_state.dart';

void showProfileEditDialog(BuildContext context) {
  final state = context.read<ProfileBloc>().state;
  final user = state is ProfileSuccessState ? state.user : null;

  final nameController = TextEditingController(text: user?.fullName ?? '');
  final emailController = TextEditingController(text: user?.email ?? '');

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
              padding: const EdgeInsets.all(AppPadding.p12),
              decoration: BoxDecoration(
                color: const Color(0xFF1a237e).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: Color(0xFF1a237e),
                size: AppSize.s28,
              ),
            ),

            const SizedBox(height: AppSize.s12),

            Text(
              "Edit Profile",
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s20,
              ),
            ),

            const SizedBox(height: AppSize.s4),

            Text(
              "Update your personal information",
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s13,
              ),
            ),

            const SizedBox(height: AppSize.s24),

            _ProfileTextField(
              controller: nameController,
              label: "Full Name",
              icon: Icons.person_outline_rounded,
            ),

            const SizedBox(height: AppSize.s16),

            _ProfileTextField(
              controller: emailController,
              label: "Email Address",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
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
                      context.read<ProfileBloc>().add(
                        UpdateProfileEvent(
                          username: nameController.text.trim(),
                          email: emailController.text.trim(),
                        ),
                      );
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Profile updated successfully!"),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.r12),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1a237e),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppPadding.p14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Save",
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

class _ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;

  const _ProfileTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F8),
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: getRegularStyle(
            color: ColorManager.textSecondary,
            fontSize: FontSize.s14,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF1a237e),
            size: AppSize.s20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFF0F2F8),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p16,
            vertical: AppPadding.p14,
          ),
        ),
      ),
    );
  }
}
