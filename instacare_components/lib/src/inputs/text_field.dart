import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/input_theme.dart';
import '../theme/typography.dart';

class InstaCareTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final bool enabled;
  final bool showPasswordToggle;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? hintColor;
  final Color? labelColor;
  final double borderRadius;

  const InstaCareTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
    this.showPasswordToggle = false,
    this.errorText,
    this.validator,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.hintColor,
    this.labelColor,
    this.borderRadius = 8,
  });

  const InstaCareTextField.password({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.enabled = true,
    this.errorText,
    this.validator,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.hintColor,
    this.labelColor,
    this.borderRadius = 8,
  })  : obscureText = true,
        keyboardType = null,
        prefixIcon = Icons.lock_outline,
        suffixIcon = null,
        maxLines = 1,
        showPasswordToggle = true;

  @override
  State<InstaCareTextField> createState() => _ICTextFieldState();
}

class _ICTextFieldState extends State<InstaCareTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: InstaCareTypography.r.copyWith(
              fontWeight: FontWeight.w600,
              color: widget.labelColor ?? AppColors.gray800,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          validator: widget.validator,
          maxLines: _obscureText ? 1 : widget.maxLines,
          enabled: widget.enabled,
          style: InstaCareTypography.r,
          decoration: InstaCareInputTheme.decoration(
            hintText: widget.hint,
            hintStyle: InstaCareTypography.r
                .copyWith(color: widget.hintColor ?? AppColors.gray400),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: AppColors.gray600)
                : null,
            suffixIcon: _buildSuffixIcon(),
            errorText: widget.errorText,
            fillColor: widget.fillColor,
            borderColor: widget.borderColor ?? AppColors.primary400,
            focusedBorderColor: widget.focusedBorderColor,
            radius: widget.borderRadius,
            counterText: '',
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.showPasswordToggle && widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: AppColors.gray600,
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      );
    }
    return widget.suffixIcon;
  }
}
