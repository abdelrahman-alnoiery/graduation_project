import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_state.dart';

import '../../../core/utils/color_maanger.dart';

class CartBadge extends StatelessWidget {
  final bool isActive;

  const CartBadge({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int itemCount = 0;
        if (state is GetCartItemsSuccessState) {
          itemCount = state.cartItems.length;
        }
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(isActive ? Icons.shopping_cart : Icons.shopping_cart_outlined),
            if (itemCount > 0)
              Positioned(
                top: -AppSize.s8,
                right: -AppSize.s8,
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
    );
  }
}
