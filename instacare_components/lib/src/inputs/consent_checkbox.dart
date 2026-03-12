import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareConsentCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String preText;
  final String linkText;
  final String postText;
  final VoidCallback? onLinkTap;

  const InstaCareConsentCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.preText = 'I have read and agree to the ',
    this.linkText = 'InstaCare Consent Form',
    this.postText =
        ' and authorize the provision of healthcare services on my behalf.',
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: Theme.of(context).colorScheme.primary,
                checkColor: AppColors.baseWhite,
                side: const BorderSide(color: AppColors.primary5, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: InstaCareTypography.r.copyWith(
                    color: AppColors.gray3,
                  ),
                  children: [
                    TextSpan(text: preText),
                    TextSpan(
                      text: linkText,
                      style: InstaCareTypography.r.copyWith(
                        color: AppColors.primary3,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = onLinkTap,
                    ),
                    TextSpan(text: postText),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
