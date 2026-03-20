import 'package:flutter/material.dart';
import '../animation/skeleton_loading.dart';
import '../types/button_size.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonSize size;
  final IconData? icon;
  final bool fullWidth;
  final _ButtonVariant _variant;
  final bool isDisabled;

  const InstaCareButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.size = ButtonSize.medium,
    this.icon,
    this.fullWidth = false,
    this.isDisabled = false,
  }) : _variant = _ButtonVariant.primary;

  const InstaCareButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.size = ButtonSize.medium,
    this.icon,
    this.fullWidth = false,
    this.isDisabled = false,
  }) : _variant = _ButtonVariant.secondary;

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

        final Color textColor = _variant == _ButtonVariant.primary
            ? AppColors.baseWhite
            : (_enabled ? AppColors.primary700 : AppColors.gray500);

        final Widget child = isLoading
            ? InstaCareSkeletonLoading(
                height: 12,
                width: skeletonWidth,
                borderRadius: const BorderRadius.all(Radius.circular(999)),
                baseColor: _variant == _ButtonVariant.primary
                    ? AppColors.baseWhite.withValues(alpha: 0.24)
                    : AppColors.gray200,
                highlightColor: _variant == _ButtonVariant.primary
                    ? AppColors.baseWhite.withValues(alpha: 0.6)
                    : AppColors.baseWhite,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: iconSize, color: textColor),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: InstaCareTypography.r.copyWith(
                        fontSize: textSize,
                        color: textColor,
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
          child: _buildButton(context, child),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context, Widget child) {
    final theme = Theme.of(context);

    switch (_variant) {
      case _ButtonVariant.primary:
        return ElevatedButton(
          onPressed: _enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _enabled ? theme.colorScheme.primary : AppColors.gray400,
            foregroundColor: AppColors.baseWhite,
            padding: size.padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: child,
        );

      case _ButtonVariant.secondary:
        return OutlinedButton(
          onPressed: _enabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor:
                _enabled ? AppColors.primary700 : AppColors.gray500,
            backgroundColor:
                _enabled ? AppColors.primary200 : AppColors.gray100,
            padding: size.padding,
            side: BorderSide(
              color: _enabled
                  ? theme.colorScheme.primary
                  : AppColors.gray400,
              width: 1.2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: child,
        );
    }
  }
}

enum _ButtonVariant { primary, secondary }