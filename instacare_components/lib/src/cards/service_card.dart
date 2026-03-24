import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../common/painters.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String priceText;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color titleColor;
  final Color bodyColor;
  final Color accentColor;

  const InstaCareServiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.priceText,
    this.onTap,
    this.backgroundColor = AppColors.serviceCardBackground,
    this.titleColor = AppColors.serviceCardTitle,
    this.bodyColor = AppColors.serviceCardBody,
    this.accentColor = AppColors.serviceCardAccent,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            constraints.maxWidth.isFinite ? constraints.maxWidth : 320.0;
        final height =
            constraints.maxHeight.isFinite ? constraints.maxHeight : 146.0;
        final widthScale = (width / 320).clamp(0.72, 1.35);
        final heightScale = (height / 146).clamp(0.72, 1.35);
        final scale = math.min(widthScale, heightScale);

        final radius = (10 * scale).clamp(8.0, 14.0);
        final horizontalPadding = (16 * widthScale).clamp(10.0, 22.0);
        final verticalPadding = (14 * heightScale).clamp(8.0, 18.0);
        final gapLarge = (8 * scale).clamp(4.0, 10.0);
        final gapSmall = (2 * scale).clamp(1.0, 4.0);
        final titleSize = (24 * scale).clamp(16.0, 30.0);
        final bodySize = (16 * scale).clamp(12.0, 18.0);
        final priceSize = (24 * scale).clamp(14.0, 26.0);
        final leafWidth = (width * 0.22).clamp(48.0, 90.0);
        final leafInset = (10 * scale).clamp(6.0, 12.0);
        final reservedRight = leafWidth + (leafInset * 1.4);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            child: Ink(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ExcludeSemantics(
                      child: CustomPaint(
                        painter: DotTexturePainter(
                          color: AppColors.baseWhite.withValues(alpha: 0.09),
                          cutOffRight: reservedRight,
                          spacing: (10 * scale).clamp(7.0, 12.0),
                          radius: (0.8 * scale).clamp(0.6, 1.2),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: leafInset,
                    top: leafInset,
                    bottom: leafInset,
                    width: leafWidth,
                    child: ExcludeSemantics(
                      child: CustomPaint(
                        painter: LeafPainter(
                          color: accentColor.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      verticalPadding,
                      reservedRight - (leafInset * 0.6),
                      verticalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          maxLines: width < 250 ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                          style: InstaCareTypography.h1.copyWith(
                            color: titleColor,
                            fontSize: titleSize,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: gapLarge),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: InstaCareTypography.body.copyWith(
                            color: bodyColor,
                            fontSize: bodySize,
                          ),
                        ),
                        SizedBox(height: gapSmall),
                        Text(
                          priceText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: InstaCareTypography.h3.copyWith(
                            color: bodyColor,
                            fontSize: priceSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
