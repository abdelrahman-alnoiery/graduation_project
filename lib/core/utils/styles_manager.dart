import 'package:flutter/material.dart';

import 'font_manager.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color) {
  return TextStyle(
    fontFamily: FontConstants.fontFamily,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}

// Light
TextStyle getLightStyle({
  required Color color,
  double fontSize = FontSize.s14,
}) {
  return _getTextStyle(fontSize, FontWeightManager.light, color);
}

// Regular
TextStyle getRegularStyle({
  required Color color,
  double fontSize = FontSize.s14,
}) {
  return _getTextStyle(fontSize, FontWeightManager.regular, color);
}

// Medium
TextStyle getMediumStyle({
  required Color color,
  double fontSize = FontSize.s14,
}) {
  return _getTextStyle(fontSize, FontWeightManager.medium, color);
}

// SemiBold
TextStyle getSemiBoldStyle({
  required Color color,
  double fontSize = FontSize.s14,
}) {
  return _getTextStyle(fontSize, FontWeightManager.semiBold, color);
}

// Bold
TextStyle getBoldStyle({required Color color, double fontSize = FontSize.s14}) {
  return _getTextStyle(fontSize, FontWeightManager.bold, color);
}
