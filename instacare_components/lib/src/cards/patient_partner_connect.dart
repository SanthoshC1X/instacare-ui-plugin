import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCarePatientPartnerConnect extends StatelessWidget {
  final String patientName;
  final String patientLabel;
  final Widget? patientAvatar;
  final String partnerName;
  final String partnerLabel;
  final Widget? partnerAvatar;

  const InstaCarePatientPartnerConnect({
    super.key,
    required this.patientName,
    this.patientLabel = 'Patient',
    this.patientAvatar,
    required this.partnerName,
    this.partnerLabel = 'Partner',
    this.partnerAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.ivory100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildProfile(
            name: patientName,
            label: patientLabel,
            avatar: patientAvatar ??
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.natural400,
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 28,
                    color: AppColors.baseWhite,
                  ),
                ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: CustomPaint(
                size: Size(double.infinity, 2),
                painter: _DottedLinePainter(color: AppColors.natural300),
              ),
            ),
          ),
          _buildProfile(
            name: partnerName,
            label: partnerLabel,
            avatar: partnerAvatar ??
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primary500,
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 28,
                    color: AppColors.baseWhite,
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile({
    required String name,
    required String label,
    required Widget avatar,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        avatar,
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: InstaCareTypography.m.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.gray800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: InstaCareTypography.s.copyWith(
                color: AppColors.gray500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;

  const _DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const dashWidth = 3.0;
    const dashGap = 5.0;
    final y = size.height / 2;
    var x = 0.0;

    while (x < size.width) {
      canvas.drawCircle(Offset(x, y), dashWidth / 2, paint);
      x += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant _DottedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
