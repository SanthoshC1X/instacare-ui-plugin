import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_flags/country_flags.dart';
import '../theme/color.dart';
import '../theme/input_theme.dart';
import '../theme/typography.dart';

class InstaCarePhoneInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String countryCode;
  final String countryIsoCode;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final int maxDigits;
  final String? requiredMessage;
  final String? lengthMessage;

  const InstaCarePhoneInput({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.countryCode = '+91',
    this.countryIsoCode = 'IN',
    this.errorText,
    this.validator,
    this.maxDigits = 10,
    this.requiredMessage,
    this.lengthMessage,
  });

  static const double _flagSize = 20;

  static const double _outerPadding = 16;
  static const double _smallGap = 8;
  static const double _codeGap = 12;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: InstaCareTypography.r.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.gray800,
            ),
          ),
          const SizedBox(height: 8),
        ],

        TextFormField(
          controller: controller,
          keyboardType: TextInputType.phone,
          onChanged: onChanged,
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return requiredMessage ?? 'Phone number is required';
                }
                if (value.length != maxDigits) {
                  return lengthMessage ?? 'Phone number must be $maxDigits digits';
                }
                return null;
              },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(maxDigits),
          ],
          style: InstaCareTypography.r,
          decoration: InstaCareInputTheme.decoration(
            hintText: hint ?? '87921 34521',
            hintStyle: InstaCareTypography.r.copyWith(
              color: AppColors.gray400,
            ),
            errorText: errorText,
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            prefixIcon: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: _outerPadding),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: _flagSize + 8,
                    height: _flagSize + 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.baseWhite,
                    ),
                    alignment: Alignment.center,
                    child: CountryFlag.fromCountryCode(
                      countryIsoCode,
                      width: _flagSize,
                      height: _flagSize,
                      borderRadius: 999,
                    ),
                  ),
                  const SizedBox(width: _smallGap),
                  Text(
                    countryCode,
                    style: InstaCareTypography.r,
                  ),
                  const SizedBox(width: _codeGap),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
