import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

import '../../../../../core/utils/color_maanger.dart';

class ColorSelector extends StatelessWidget {
  final List<String> colors;
  final String selectedColor;
  final Function(String) onColorSelected;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final color = colors[index];
          final isSelected = selectedColor == color;
          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: Container(
              margin: const EdgeInsets.only(right: AppMargin.m8),
              width: AppSize.s32,
              height: AppSize.s32,
              decoration: BoxDecoration(
                color: _parseColor(color),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? ColorManager.primary
                      : ColorManager.transparent,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: ColorManager.grey.withOpacity(0.3),
                          blurRadius: 4,
                        ),
                      ]
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Color _parseColor(String colorStr) {
    try {
      return Color(int.parse(colorStr.replaceAll('#', '0xFF')));
    } catch (_) {
      return ColorManager.grey;
    }
  }
}
