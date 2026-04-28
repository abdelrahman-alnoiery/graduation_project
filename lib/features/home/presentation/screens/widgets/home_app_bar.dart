import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/assets_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_state.dart';

import '../../../../../core/utils/color_maanger.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;

  const HomeAppBar({
    super.key,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorManager.primary,
      elevation: 0,
      title: Image.asset(ImageAssets.logo, height: AppSize.s40),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(AppSize.s60),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p16,
            vertical: AppPadding.p8,
          ),
          child: TextField(
            controller: searchController,
            onChanged: onSearch,
            style: const TextStyle(color: ColorManager.white),
            decoration: InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(color: ColorManager.white.withOpacity(0.7)),
              prefixIcon: const Icon(Icons.search, color: ColorManager.white),
              filled: true,
              fillColor: ColorManager.white.withOpacity(0.2),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.r50),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      actions: [
        // ── Cart Icon with Badge ─────────────────
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            int itemCount = 0;
            if (state is GetCartItemsSuccessState) {
              itemCount = state.cartItems.length;
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.cartRoute);
                  },
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: ColorManager.white,
                  ),
                ),
                if (itemCount > 0)
                  Positioned(
                    top: AppSize.s8,
                    right: AppSize.s8,
                    child: Container(
                      width: AppSize.s16,
                      height: AppSize.s16,
                      decoration: const BoxDecoration(
                        color: ColorManager.error,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          itemCount > 9 ? "9+" : "$itemCount",
                          style: const TextStyle(
                            color: ColorManager.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + AppSize.s60);
}
