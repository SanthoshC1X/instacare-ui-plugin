import 'package:flutter/material.dart';
import '../animation/skeleton_loading.dart';
import '../types/button_size.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareDangerButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonSize size;
  final IconData? icon;
  final bool fullWidth;
  final bool isDisabled;

  const InstaCareDangerButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.size = ButtonSize.medium,
    this.icon,
    this.fullWidth = false,
    this.isDisabled = false,
  });

  bool get _enabled => onPressed != null && !isLoading && !isDisabled;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            constraints.maxWidth.isFinite ? constraints.maxWidth : 320.0;
        final textSize = (width * 0.045).clamp(13.0, 16.0);
        final iconSize = (width * 0.05).clamp(16.0, 18.0);
        final skeletonWidth = (width * 0.34).clamp(56.0, 120.0);

        final Widget child = isLoading
            ? InstaCareSkeletonLoading(
                height: 12,
                width: skeletonWidth,
                borderRadius: const BorderRadius.all(Radius.circular(999)),
                baseColor: AppColors.baseWhite.withValues(alpha: 0.24),
                highlightColor: AppColors.baseWhite.withValues(alpha: 0.6),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: iconSize, color: AppColors.baseWhite),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: InstaCareTypography.r.copyWith(
                        fontSize: textSize,
                        color: AppColors.baseWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );

        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: size.height < 48 ? 48 : size.height,
            minWidth: fullWidth ? width : 0,
          ),
          child: ElevatedButton(
            onPressed: _enabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _enabled ? AppColors.error1 : AppColors.gray6,
              foregroundColor: AppColors.baseWhite,
              padding: size.padding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              elevation: 0,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
