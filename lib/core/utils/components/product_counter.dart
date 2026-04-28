import 'package:flutter/material.dart';

import '../color_maanger.dart';
import '../font_manager.dart';
import '../styles_manager.dart';
import '../values_manager.dart';

class ProductCounter extends StatelessWidget {
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final int minCount;
  final int maxCount;

  const ProductCounter({
    super.key,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    this.minCount = 1,
    this.maxCount = 99,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.r8),
        border: Border.all(color: ColorManager.lightGrey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Decrement Button ──────────────────────────
          _CounterButton(
            icon: Icons.remove,
            onTap: count <= minCount ? null : onDecrement,
            isDisabled: count <= minCount,
          ),

          // ── Count ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
            child: Text(
              "$count",
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s16,
              ),
            ),
          ),

          // ── Increment Button ──────────────────────────
          _CounterButton(
            icon: Icons.add,
            onTap: count >= maxCount ? null : onIncrement,
            isDisabled: count >= maxCount,
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isDisabled;

  const _CounterButton({
    required this.icon,
    required this.onTap,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSize.s32,
        height: AppSize.s32,
        decoration: BoxDecoration(
          color: isDisabled ? ColorManager.lightGrey : ColorManager.primary,
          borderRadius: BorderRadius.circular(AppRadius.r8),
        ),
        child: Icon(
          icon,
          color: isDisabled ? ColorManager.grey : ColorManager.white,
          size: AppSize.s16,
        ),
      ),
    );
  }
}
