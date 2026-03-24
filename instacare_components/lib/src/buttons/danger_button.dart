import 'package:flutter/material.dart';
import '../types/button_size.dart';
import 'button.dart';

/// Convenience alias for [InstaCareButton.danger].
///
/// Kept for backward compatibility. Prefer using `InstaCareButton.danger`
/// directly in new code.
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

  @override
  Widget build(BuildContext context) {
    return InstaCareButton.danger(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      size: size,
      icon: icon,
      fullWidth: fullWidth,
      isDisabled: isDisabled,
    );
  }
}
