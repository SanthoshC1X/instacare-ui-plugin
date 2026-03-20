import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareAttemptsCard extends StatelessWidget {
  final int totalAttempts;
  final int usedAttempts;
  final bool hasPassed;

  const InstaCareAttemptsCard({
    super.key,
    required this.totalAttempts,
    required this.usedAttempts,
    required this.hasPassed,
  });

  @override
  Widget build(BuildContext context) {
    final int remaining = totalAttempts - usedAttempts;
    final bool isExhausted = usedAttempts >= totalAttempts;

    /// ============================
    /// 🟢 PASSED STATE
    /// ============================
    if (hasPassed) {
      return _buildStatusCard(
        color: AppColors.successFg,
        bgColor: AppColors.successBg,
        icon: Icons.check_circle_outline,
        title: 'Assessment Cleared',
        description:
            'Congratulations! You have successfully completed and passed this assessment.',
      );
    }

    /// ============================
    /// 🔴 FAILED STATE (EXHAUSTED)
    /// ============================
    if (isExhausted) {
      return _buildStatusCard(
        color: AppColors.errorFg,
        bgColor: AppColors.errorBg,
        icon: Icons.error_outline,
        title: 'Attempts Exhausted',
        description:
            'You have used all available attempts and did not pass. Please contact the admin for further assistance.',
      );
    }

    /// ============================
    /// 🟡 IN-PROGRESS STATE
    /// ============================
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isSmallScreen = width < 360;
        
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.warningBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.warningFg.withValues(alpha:0.3),
              width: 1,
            ),
          ),
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HEADER
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIcon(AppColors.warningFg, Icons.trending_up, isSmallScreen),
                  SizedBox(width: isSmallScreen ? 10 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attempts Remaining',
                          style: InstaCareTypography.r.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.gray800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'You have used $usedAttempts out of $totalAttempts attempts for this assessment.',
                          style: InstaCareTypography.r.copyWith(
                            color: AppColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),

              /// SEGMENTED PROGRESS BAR
              Row(
                children: List.generate(
                  totalAttempts,
                  (index) => Expanded(
                    child: Container(
                      height: 8,
                      margin: EdgeInsets.only(
                        right: index == totalAttempts - 1 ? 0 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: index < usedAttempts
                            ? AppColors.warningFg
                            : AppColors.warningFg.withValues(alpha:0.25),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              /// FOOTER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      '$remaining ${remaining == 1 ? 'attempt' : 'attempts'} left',
                      style: InstaCareTypography.r.copyWith(
                        color: AppColors.warningFg,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '$usedAttempts / $totalAttempts used',
                    style: InstaCareTypography.r.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// ============================
  /// ♻️ REUSABLE STATUS CARD
  /// ============================
  Widget _buildStatusCard({
    required Color color,
    required Color bgColor,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isSmallScreen = width < 360;
        
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha:0.3),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(color, icon, isSmallScreen),
              SizedBox(width: isSmallScreen ? 10 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: InstaCareTypography.r.copyWith(
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: InstaCareTypography.r.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIcon(Color color, IconData icon, bool isSmall) {
    final size = isSmall ? 40.0 : 44.0;
    final iconSize = isSmall ? 20.0 : 22.0;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppColors.baseWhite,
        size: iconSize,
      ),
    );
  }
}
