import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/input_theme.dart';
import '../theme/typography.dart';

class InstaCareSearchBar extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const InstaCareSearchBar({
    super.key,
    this.hint = 'Search',
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: InstaCareTypography.r,
      decoration: InstaCareInputTheme.decoration(
        hintText: hint,
        hintStyle: InstaCareTypography.r.copyWith(
          color: AppColors.gray400,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.gray600,
        ),
      ),
    );
  }
}
