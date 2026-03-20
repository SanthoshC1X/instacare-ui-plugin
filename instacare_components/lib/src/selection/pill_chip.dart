import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCarePillChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const InstaCarePillChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        selected ? Theme.of(context).colorScheme.primary : AppColors.primary300;
    final backgroundColor = selected ? AppColors.primary100 : AppColors.baseWhite;
    final textColor =
        selected ? Theme.of(context).colorScheme.primary : AppColors.gray700;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: InstaCareTypography.r.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
