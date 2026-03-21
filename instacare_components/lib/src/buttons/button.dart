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

        final Color textColor;
        switch (_variant) {
          case _ButtonVariant.primary:
            textColor = _enabled ? AppColors.baseWhite : AppColors.gray400;
          case _ButtonVariant.secondary:
            textColor = _enabled ? AppColors.primary700 : AppColors.gray400;
        }

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
          child: _buildButton(context, child),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context, Widget child) {
    switch (_variant) {
      case _ButtonVariant.primary:
        return ElevatedButton(
          onPressed: _enabled ? onPressed : null,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.gray200;
              }
              if (states.contains(WidgetState.pressed)) {
                return AppColors.primary900;
              }
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused)) {
                return AppColors.primary800;
              }
              return AppColors.primary700;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.gray400;
              }
              return AppColors.baseWhite;
            }),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return AppColors.baseWhite.withValues(alpha: 0.1);
              }
              return null;
            }),
            padding: WidgetStateProperty.all(size.padding),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            elevation: WidgetStateProperty.all(0),
          ),
          child: child,
        );

      case _ButtonVariant.secondary:
        return OutlinedButton(
          onPressed: _enabled ? onPressed : null,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.gray50;
              }
              if (states.contains(WidgetState.pressed)) {
                return AppColors.primary100;
              }
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused)) {
                return AppColors.primary50;
              }
              return AppColors.baseWhite;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.gray400;
              }
              if (states.contains(WidgetState.pressed)) {
                return AppColors.primary900;
              }
              return AppColors.primary700;
            }),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return AppColors.primary700.withValues(alpha: 0.08);
              }
              return null;
            }),
            side: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return const BorderSide(color: AppColors.gray300, width: 1.2);
              }
              if (states.contains(WidgetState.pressed)) {
                return const BorderSide(color: AppColors.primary900, width: 1.2);
              }
              if (states.contains(WidgetState.focused)) {
                return const BorderSide(color: AppColors.primary800, width: 1.6);
              }
              return const BorderSide(color: AppColors.primary700, width: 1.2);
            }),
            padding: WidgetStateProperty.all(size.padding),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: child,
        );
    }
  }
}

enum _ButtonVariant { primary, secondary }
