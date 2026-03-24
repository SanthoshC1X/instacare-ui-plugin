import 'package:flutter/material.dart';
import 'color.dart';

class InstaCareInputTheme {
  InstaCareInputTheme._();

  static const double borderRadius = 8;
  static const EdgeInsets contentPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 14);

  static InputDecoration decoration({
    String? hintText,
    TextStyle? hintStyle,
    Widget? prefixIcon,
    Widget? suffixIcon,
    BoxConstraints? prefixIconConstraints,
    String? errorText,
    String? counterText,
    Color? fillColor,
    Color? borderColor,
    Color? focusedBorderColor,
    double radius = borderRadius,
  }) {
    final effectiveFillColor = fillColor ?? AppColors.ivory300;
    final effectiveBorderColor = borderColor ?? AppColors.primary700;
    final effectiveFocusedColor = focusedBorderColor ?? AppColors.primary900;

    return InputDecoration(
      hintText: hintText,
      hintStyle: hintStyle,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      prefixIconConstraints: prefixIconConstraints,
      errorText: errorText,
      counterText: counterText,
      filled: true,
      fillColor: effectiveFillColor,
      contentPadding: contentPadding,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: effectiveBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: effectiveBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: effectiveFocusedColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: AppColors.error700),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: AppColors.error700, width: 2),
      ),
    );
  }
}
