import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';
import '../types/feedback_type.dart';

@Deprecated('Use InstaCareFeedbackType instead')
typedef InstaCareMessageType = InstaCareFeedbackType;

class InstaCareMessageBox extends StatelessWidget {
  final InstaCareFeedbackType type;
  final String title;
  final String body;

  const InstaCareMessageBox({
    super.key,
    required this.type,
    required this.title,
    required this.body,
  });

  IconData get _icon {
    switch (type) {
      case InstaCareFeedbackType.info:
        return Icons.info_outline;
      case InstaCareFeedbackType.error:
        return Icons.error_outline;
      case InstaCareFeedbackType.pending:
        return Icons.hourglass_top;
      case InstaCareFeedbackType.success:
        return Icons.check_circle_outline;
    }
  }

  Color _backgroundColor() {
    switch (type) {
      case InstaCareFeedbackType.info:
        return AppColors.infoBg;
      case InstaCareFeedbackType.error:
        return AppColors.errorBg;
      case InstaCareFeedbackType.pending:
        return AppColors.warningBg;
      case InstaCareFeedbackType.success:
        return AppColors.successBg;
    }
  }

  Color _foregroundColor() {
    switch (type) {
      case InstaCareFeedbackType.info:
        return AppColors.infoFg;
      case InstaCareFeedbackType.error:
        return AppColors.errorFg;
      case InstaCareFeedbackType.pending:
        return AppColors.warningFg;
      case InstaCareFeedbackType.success:
        return AppColors.successFg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fg = _foregroundColor();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_icon, size: 18, color: fg),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: InstaCareTypography.r.copyWith(
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: InstaCareTypography.r.copyWith(color: fg),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
