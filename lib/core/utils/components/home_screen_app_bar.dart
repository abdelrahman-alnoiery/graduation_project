import 'package:flutter/material.dart';

import '../assets_manager.dart';
import '../color_maanger.dart';
import '../font_manager.dart';
import '../styles_manager.dart';
import '../values_manager.dart';

class HomeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onCartTap;
  final VoidCallback onSearchTap;
  final int cartItemCount;

  const HomeScreenAppBar({
    super.key,
    required this.onCartTap,
    required this.onSearchTap,
    this.cartItemCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorManager.primary,
      elevation: 0,
      title: Image.asset(ImageAssets.logo, height: AppSize.s40),
      actions: [
        // Search Icon
        IconButton(
          onPressed: onSearchTap,
          icon: const Icon(
            Icons.search,
            color: ColorManager.white,
            size: AppSize.s24,
          ),
        ),

        // Cart Icon with Badge
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: onCartTap,
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: ColorManager.white,
                size: AppSize.s24,
              ),
            ),
            if (cartItemCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: AppSize.s16,
                  height: AppSize.s16,
                  decoration: const BoxDecoration(
                    color: ColorManager.error,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      cartItemCount > 9 ? "9+" : "$cartItemCount",
                      style: getBoldStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(width: AppSize.s8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
