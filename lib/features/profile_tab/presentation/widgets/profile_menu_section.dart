import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/color_maanger.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

class ProfileMenuSection extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onAddProduct;
  final VoidCallback onOrders;
  final VoidCallback onAbout;

  const ProfileMenuSection({
    super.key,
    required this.onEditProfile,
    required this.onAddProduct,
    required this.onOrders,
    required this.onAbout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _ProfileMenuItem(
            icon: Icons.person_outline_rounded,
            title: "Edit Profile",
            subtitle: "Update your information",
            color: const Color(0xFF1a237e),
            onTap: onEditProfile,
          ),
          _buildDivider(),
          _ProfileMenuItem(
            icon: Icons.add_box_outlined,
            title: "Add Product",
            subtitle: "List a new product for sale",
            color: const Color(0xFF1b5e20),
            onTap: onAddProduct,
          ),
          _buildDivider(),
          _ProfileMenuItem(
            icon: Icons.shopping_bag_outlined,
            title: "My Orders",
            subtitle: "Track your orders",
            color: const Color(0xFF0d47a1),
            onTap: onOrders,
          ),
          _buildDivider(),
          _ProfileMenuItem(
            icon: Icons.info_outline_rounded,
            title: "About CarGo",
            subtitle: "Version 1.0.0",
            color: const Color(0xFF1b5e20),
            onTap: onAbout,
            showArrow: false,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.withOpacity(0.08),
      indent: AppPadding.p16 + AppSize.s22 + AppPadding.p10 * 2 + AppPadding.p14,
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final bool showArrow;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r20),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p14,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppPadding.p10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: Icon(icon, color: color, size: AppSize.s22),
            ),
            const SizedBox(width: AppSize.s14),
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
            if (showArrow)
              Container(
                padding: const EdgeInsets.all(AppPadding.p4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: ColorManager.grey,
                  size: AppSize.s14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
