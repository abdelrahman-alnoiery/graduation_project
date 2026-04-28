import 'package:flutter/material.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/assets_manager.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

import '../../../../../core/utils/color_maanger.dart';
import '../../../../../core/utils/components/main_button.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image
            Image.asset(ImageAssets.emptyCart, height: AppSize.s200),

            const SizedBox(height: AppSize.s24),

            // Title
            Text(
              "No Cart Is Empty",
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s20,
              ),
            ),

            const SizedBox(height: AppSize.s8),

            // SubTitle
            Text(
              "Start shopping to add items to your cart",
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s14,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSize.s32),

            // Shop Now Button
            MainButton(
              title: "Shop Now",
              onPressed: () {
                Navigator.pushNamed(context, Routes.productsScreenRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
