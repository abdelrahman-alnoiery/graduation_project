import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_bloc.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_event.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_state.dart';

import '../../../../core/utils/color_maanger.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is LogoutSuccessState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.signInRoute,
              (route) => false,
            );
          }
          if (state is ProfileErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorManager.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: ColorManager.primary),
            );
          }

          if (state is ProfileSuccessState) {
            final user = state.user;
            return SingleChildScrollView(
              child: Column(
                children: [
                  // ── Header ──────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(
                      AppPadding.p16,
                      AppPadding.p60,
                      AppPadding.p16,
                      AppPadding.p24,
                    ),
                    decoration: const BoxDecoration(
                      color: ColorManager.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(AppRadius.r24),
                        bottomRight: Radius.circular(AppRadius.r24),
                      ),
                    ),
                    child: Column(
                      children: [
                        // ── Avatar ────────────────
                        CircleAvatar(
                          radius: AppSize.s48,
                          backgroundColor: ColorManager.white,
                          child: Text(
                            user.firstName.isNotEmpty
                                ? user.firstName[0].toUpperCase()
                                : 'U',
                            style: getBoldStyle(
                              color: ColorManager.primary,
                              fontSize: FontSize.s32,
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSize.s12),

                        // ── Name ──────────────────
                        Text(
                          user.fullName,
                          style: getBoldStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s20,
                          ),
                        ),

                        const SizedBox(height: AppSize.s4),

                        // ── Email ─────────────────
                        Text(
                          user.email,
                          style: getRegularStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s14,
                          ),
                        ),

                        const SizedBox(height: AppSize.s8),

                        // ── Role Badge ────────────
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p12,
                            vertical: AppPadding.p4,
                          ),
                          decoration: BoxDecoration(
                            color: ColorManager.white,
                            borderRadius: BorderRadius.circular(AppRadius.r50),
                          ),
                          child: Text(
                            user.role?.toUpperCase() ?? 'SELLER',
                            style: getMediumStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSize.s16),

                  // ── Info Cards ───────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p16,
                    ),
                    child: Column(
                      children: [
                        // ── My Orders ─────────────
                        _buildMenuCard(
                          icon: Icons.shopping_bag_outlined,
                          title: "My Orders",
                          subtitle: "Track your orders",
                          onTap: () {},
                        ),

                        const SizedBox(height: AppSize.s12),

                        // ── Edit Profile ──────────
                        _buildMenuCard(
                          icon: Icons.edit_outlined,
                          title: "Edit Profile",
                          subtitle: "Update your information",
                          onTap: () => _showEditDialog(context, user),
                        ),

                        const SizedBox(height: AppSize.s12),

                        // ── About ─────────────────
                        _buildMenuCard(
                          icon: Icons.info_outline,
                          title: "About CarGo",
                          subtitle: "Version 1.0.0",
                          onTap: () {},
                        ),

                        const SizedBox(height: AppSize.s24),

                        // ── Logout Button ─────────
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showLogoutDialog(context),
                            icon: const Icon(
                              Icons.logout,
                              color: ColorManager.white,
                            ),
                            label: Text(
                              "Logout",
                              style: getBoldStyle(
                                color: ColorManager.white,
                                fontSize: FontSize.s16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.error,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppPadding.p16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.r12,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSize.s24),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          // ── Error ────────────────────────────────
          if (state is ProfileErrorState) {
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
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSize.s16),
                  ElevatedButton(
                    onPressed: () => context.read<ProfileBloc>().add(
                      const GetProfileEvent(),
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
    );
  }

  // ── Menu Card ─────────────────────────────────────
  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p16),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          boxShadow: [
            BoxShadow(
              color: ColorManager.grey,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppPadding.p10),
              decoration: BoxDecoration(
                color: ColorManager.primary,
                borderRadius: BorderRadius.circular(AppRadius.r10),
              ),
              child: Icon(icon, color: ColorManager.primary, size: AppSize.s24),
            ),
            const SizedBox(width: AppSize.s16),
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

  // ── Edit Dialog ───────────────────────────────────
  void _showEditDialog(BuildContext context, user) {
    final nameController = TextEditingController(text: user.fullName);
    final emailController = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Edit Profile",
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Username",
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: AppSize.s12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProfileBloc>().add(
                UpdateProfileEvent(
                  username: nameController.text.trim(),
                  email: emailController.text.trim(),
                ),
              );
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primary,
            ),
            child: const Text(
              "Save",
              style: TextStyle(color: ColorManager.white),
            ),
          ),
        ],
      ),
    );
  }

  // ── Logout Dialog ─────────────────────────────────
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Logout",
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s18,
          ),
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: getRegularStyle(
            color: ColorManager.textSecondary,
            fontSize: FontSize.s14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ProfileBloc>().add(const LogoutEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.error,
            ),
            child: const Text(
              "Logout",
              style: TextStyle(color: ColorManager.white),
            ),
          ),
        ],
      ),
    );
  }
}
