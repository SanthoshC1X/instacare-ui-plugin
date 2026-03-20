import 'package:flutter/material.dart';
import 'card.dart';
import '../buttons/button.dart';
import '../theme/color.dart';
import '../theme/typography.dart';
import '../types/button_size.dart';

class InstaCareIncomeTile extends StatelessWidget {
  final String title;
  final String amount;
  final String redeemButtonText;
  final VoidCallback? onRedeem;
  final Color? backgroundColor;

  const InstaCareIncomeTile({
    super.key,
    required this.title,
    required this.amount,
    required this.redeemButtonText,
    this.onRedeem,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InstaCareCard(
      backgroundColor: backgroundColor,
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: InstaCareTypography.h2.copyWith(
              fontSize: 18,
              color: AppColors.gray800,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            textAlign: TextAlign.center,
            style: InstaCareTypography.h1.copyWith(
              color: AppColors.gray900,
              fontSize: 56,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          if (onRedeem != null) ...[
            const SizedBox(height: 16),
            InstaCareButton(
              text: redeemButtonText,
              onPressed: onRedeem,
              fullWidth: true,
              size: ButtonSize.medium,
            ),
          ],
        ],
      ),
    );
  }
}
