import 'package:flutter/material.dart';
import '../theme/color.dart';
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
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: InstaCareTypography.r.copyWith(
          color: AppColors.gray400,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.gray600,
        ),
        filled: true,
        fillColor: AppColors.ivory300,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.primary900,
            width: 2,
          ),
        ),
      ),
    );
  }
}
