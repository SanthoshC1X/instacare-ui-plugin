import 'package:flutter/material.dart';
import 'color.dart';
import 'typography.dart';

/// InstaCare Heading Components
/// Provides consistent heading styles across the app
class InstaCareHeading {
  /// Top Header Title - Used for main page headers
  static Widget topHeaderTitle(String text, {Color? color}) {
    return Text(
      text,
      style: InstaCareTypography.h2.copyWith(
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.gray800,
      ),
    );
  }

  /// Title with Back Button - Used for navigation headers
  static Widget titleWithBackButton({
    required String text,
    VoidCallback? onBackPressed,
    Color? color,
  }) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.gray900,
            size: 28,
          ),
          onPressed: onBackPressed,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: InstaCareTypography.h3.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.gray900,
          ),
        ),
      ],
    );
  }
}
