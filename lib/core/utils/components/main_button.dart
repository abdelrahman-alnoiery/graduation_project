import 'package:flutter/material.dart';

import '../color_maanger.dart';
import '../font_manager.dart';
import '../styles_manager.dart';
import '../values_manager.dart';

class MainButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final bool isLoading;
  final bool isOutlined;
  final IconData? prefixIcon;

  const MainButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.height,
    this.fontSize,
    this.isLoading = false,
    this.isOutlined = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppSize.s40,
      child: isOutlined ? _buildOutlinedButton() : _buildFilledButton(),
    );
  }

  // Filled Button
  Widget _buildFilledButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? ColorManager.primary,
        disabledBackgroundColor: ColorManager.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
      ),
      child: _buildChild(textColor ?? ColorManager.white),
    );
  }

  // Outlined Button
  Widget _buildOutlinedButton() {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor ?? ColorManager.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
      ),
      child: _buildChild(textColor ?? ColorManager.primary),
    );
  }

  // Child Widget
  Widget _buildChild(Color color) {
    if (isLoading) {
      return CircularProgressIndicator(color: color, strokeWidth: 2);
    }
    if (prefixIcon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(prefixIcon, color: color, size: AppSize.s20),
          SizedBox(width: AppSize.s8),
          Text(
            title,
            style: getBoldStyle(
              color: color,
              fontSize: fontSize ?? FontSize.s16,
            ),
          ),
        ],
      );
    }
    return Text(
      title,
      style: getBoldStyle(color: color, fontSize: fontSize ?? FontSize.s16),
    );
  }
}
