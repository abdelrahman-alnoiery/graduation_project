import 'package:flutter/material.dart';

import '../color_maanger.dart';
import '../font_manager.dart';
import '../styles_manager.dart';
import '../values_manager.dart';

class MainTextField extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final int? maxLines;
  final bool enabled;
  final void Function(String)? onChanged;

  const MainTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.labelText,
    this.keyboardType,
    this.isPassword = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.maxLines = 1,
    this.enabled = true,
    this.onChanged,
  });

  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword ? _obscureText : false,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      validator: widget.validator,
      style: getRegularStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s14,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        hintStyle: getRegularStyle(
          color: ColorManager.grey,
          fontSize: FontSize.s20,
        ),
        labelStyle: getMediumStyle(
          color: ColorManager.grey,
          fontSize: FontSize.s14,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: ColorManager.primary,
                size: AppSize.s24,
              )
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: ColorManager.grey,
                  size: AppSize.s20,
                ),
              )
            : widget.suffixIcon != null
            ? IconButton(
                onPressed: widget.onSuffixTap,
                icon: Icon(
                  widget.suffixIcon,
                  color: ColorManager.grey,
                  size: AppSize.s20,
                ),
              )
            : null,
        filled: true,
        fillColor: ColorManager.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
          borderSide: const BorderSide(color: ColorManager.lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r16),
          borderSide: const BorderSide(color: ColorManager.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
          borderSide: const BorderSide(color: ColorManager.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
          borderSide: const BorderSide(color: ColorManager.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
          borderSide: const BorderSide(color: ColorManager.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
          borderSide: const BorderSide(color: ColorManager.lightGrey),
        ),
      ),
    );
  }
}
