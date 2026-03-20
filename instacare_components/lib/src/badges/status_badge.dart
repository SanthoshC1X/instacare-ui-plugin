import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

enum InstaCareStatusBadgeType {
  active,
  upcoming,
  cancelled,
  inTravel,
  completed,
  custom
}

class InstaCareStatusBadge extends StatelessWidget {
  final String label;
  final InstaCareStatusBadgeType type;

  const InstaCareStatusBadge({
    super.key,
    required this.label,
    this.type = InstaCareStatusBadgeType.custom,
  });

  Color _backgroundColor(BuildContext context) {
    switch (type) {
      case InstaCareStatusBadgeType.active:
        return AppColors.success200;
      case InstaCareStatusBadgeType.upcoming:
        return AppColors.secondary200;
      case InstaCareStatusBadgeType.cancelled:
        return AppColors.error100;
      case InstaCareStatusBadgeType.inTravel:
        return AppColors.ivory900;
      case InstaCareStatusBadgeType.completed:
        return AppColors.infoBg;
      case InstaCareStatusBadgeType.custom:
        return Theme.of(context).colorScheme.surfaceContainerHighest;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: _backgroundColor(context),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: InstaCareTypography.r.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.primary800,
        ),
      ),
    );
  }
}
