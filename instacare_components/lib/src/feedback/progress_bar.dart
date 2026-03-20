import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareProgressBar extends StatelessWidget {
  final double value;
  final String? label;

  const InstaCareProgressBar({
    super.key,
    required this.value,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: InstaCareTypography.r.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 10,
            value: clamped,
            backgroundColor: AppColors.gray200,
            valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${(clamped * 100).round()}% completed',
          style: InstaCareTypography.r.copyWith(color: AppColors.gray600),
        ),
      ],
    );
  }
}
