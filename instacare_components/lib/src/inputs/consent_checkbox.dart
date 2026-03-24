import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareConsentCheckbox extends StatefulWidget {
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
  State<InstaCareConsentCheckbox> createState() =>
      _InstaCareConsentCheckboxState();
}

class _InstaCareConsentCheckboxState extends State<InstaCareConsentCheckbox> {
  late final TapGestureRecognizer _linkRecognizer;

  @override
  void initState() {
    super.initState();
    _linkRecognizer = TapGestureRecognizer()..onTap = widget.onLinkTap;
  }

  @override
  void didUpdateWidget(covariant InstaCareConsentCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.onLinkTap != widget.onLinkTap) {
      _linkRecognizer.onTap = widget.onLinkTap;
    }
  }

  @override
  void dispose() {
    _linkRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => widget.onChanged(!widget.value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: widget.value,
                onChanged: widget.onChanged,
                activeColor: Theme.of(context).colorScheme.primary,
                checkColor: AppColors.baseWhite,
                side: const BorderSide(
                    color: AppColors.primary500, width: 1.5),
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
                    color: AppColors.gray700,
                  ),
                  children: [
                    TextSpan(text: widget.preText),
                    TextSpan(
                      text: widget.linkText,
                      style: InstaCareTypography.r.copyWith(
                        color: AppColors.primary700,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: _linkRecognizer,
                    ),
                    TextSpan(text: widget.postText),
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
