import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

import '../../../../../core/utils/color_maanger.dart';

class SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String selectedSize;
  final Function(String) onSizeSelected;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sizes.length,
        itemBuilder: (context, index) {
          final size = sizes[index];
          final isSelected = selectedSize == size;
          return GestureDetector(
            onTap: () => onSizeSelected(size),
            child: Container(
              margin: const EdgeInsets.only(right: AppMargin.m8),
              width: AppSize.s40,
              height: AppSize.s40,
              decoration: BoxDecoration(
                color: isSelected ? ColorManager.primary : ColorManager.white,
                borderRadius: BorderRadius.circular(AppRadius.r8),
                border: Border.all(
                  color: isSelected
                      ? ColorManager.primary
                      : ColorManager.lightGrey,
                ),
              ),
              child: Center(
                child: Text(
                  size,
                  style: getMediumStyle(
                    color: isSelected
                        ? ColorManager.white
                        : ColorManager.textPrimary,
                    fontSize: FontSize.s12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
