import 'package:flutter/material.dart';

import '../color_maanger.dart';
import '../font_manager.dart';
import '../styles_manager.dart';
import '../values_manager.dart';

class CustomElevatedButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final bool isLoading;

  const CustomElevatedButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.fontSize,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppSize.s48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? ColorManager.primary,
          disabledBackgroundColor: ColorManager.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.r12),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                color: ColorManager.white,
                strokeWidth: 2,
              )
            : Text(
                title,
                style: getBoldStyle(
                  color: textColor ?? ColorManager.white,
                  fontSize: fontSize ?? FontSize.s16,
                ),
              ),
      ),
    );
  }
}
