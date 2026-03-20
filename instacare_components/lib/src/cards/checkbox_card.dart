import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareCheckboxCard extends StatelessWidget {
  final String title;
  final String message;
  final bool isSelected;
  final ValueChanged<bool>? onChanged;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final Color? borderColor;
  final Color? selectedBorderColor;

  const InstaCareCheckboxCard({
    super.key,
    required this.title,
    required this.message,
    required this.isSelected,
    this.onChanged,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.borderColor,
    this.selectedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged != null ? () => onChanged!(!isSelected) : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedBackgroundColor ?? AppColors.primary100)
              : (backgroundColor ?? AppColors.ivory300),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? (selectedBorderColor ?? AppColors.primary700)
                : (borderColor ?? AppColors.primary700),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: Checkbox(
                value: isSelected,
                onChanged: onChanged != null
                    ? (bool? value) => onChanged!(value ?? false)
                    : null,
                side: const BorderSide(color: AppColors.primary700),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: InstaCareTypography.r.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: InstaCareTypography.r.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
