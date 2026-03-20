import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareServiceCategory {
  final String name;
  final String description;
  final String price;
  final String? imagePath;

  const InstaCareServiceCategory({
    required this.name,
    required this.description,
    required this.price,
    this.imagePath,
  });
}

class InstaCareServiceCategoryGrid extends StatelessWidget {
  final List<InstaCareServiceCategory> categories;
  final ValueChanged<InstaCareServiceCategory>? onCategoryTap;

  const InstaCareServiceCategoryGrid({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _ServiceCategoryCard(
          category: category,
          onTap: () => onCategoryTap?.call(category),
        );
      },
    );
  }
}

class _ServiceCategoryCard extends StatelessWidget {
  final InstaCareServiceCategory category;
  final VoidCallback? onTap;

  const _ServiceCategoryCard({
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: category.imagePath != null
          ? _buildImageCard()
          : _buildPaintedCard(),
    );
  }

  Widget _buildImageCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray300.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        category.imagePath!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildPaintedCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = w / 1.35;
        final leafWidth = w * 0.35;
        final leafInset = w * 0.04;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.serviceCardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _DotTexturePainter(
                    color: AppColors.baseWhite.withValues(alpha: 0.09),
                    cutOffRight: leafWidth,
                    spacing: 10,
                    radius: 0.8,
                  ),
                ),
              ),
              Positioned(
                right: leafInset,
                top: leafInset,
                bottom: leafInset,
                width: leafWidth,
                child: CustomPaint(
                  painter: _LeafBranchPainter(
                    color:
                        AppColors.serviceCardAccent.withValues(alpha: 0.7),
                    scale: h / 120,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: InstaCareTypography.h3.copyWith(
                        color: AppColors.serviceCardTitle,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.description,
                      style: InstaCareTypography.s.copyWith(
                        color: AppColors.serviceCardBody,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      category.price,
                      style: InstaCareTypography.s.copyWith(
                        color: AppColors.serviceCardBody,
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
}

Future<void> showServiceCategoryDialog({
  required BuildContext context,
  required InstaCareServiceCategory category,
  String navigateLabel = 'Go to Service',
  VoidCallback? onNavigate,
}) {
  return showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.serviceCardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: category.imagePath != null
                  ? Image.asset(
                      category.imagePath!,
                      fit: BoxFit.cover,
                    )
                  : CustomPaint(
                      size: const Size(120, 120),
                      painter: _LeafBranchPainter(
                        color: AppColors.serviceCardAccent
                            .withValues(alpha: 0.85),
                        scale: 1.2,
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              category.name,
              style: InstaCareTypography.h2.copyWith(
                color: AppColors.gray800,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              category.description,
              style: InstaCareTypography.r.copyWith(
                color: AppColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              category.price,
              style: InstaCareTypography.m.copyWith(
                color: AppColors.primary700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onNavigate?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary700,
                  foregroundColor: AppColors.baseWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  navigateLabel,
                  style: InstaCareTypography.m.copyWith(
                    color: AppColors.baseWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Painters
// ---------------------------------------------------------------------------

class _DotTexturePainter extends CustomPainter {
  final Color color;
  final double cutOffRight;
  final double spacing;
  final double radius;

  const _DotTexturePainter({
    required this.color,
    required this.cutOffRight,
    required this.spacing,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final maxX = size.width - cutOffRight;
    final startY = spacing + 4;
    final endY = size.height - spacing;

    for (double y = startY; y < endY; y += spacing) {
      final rowOffset = ((y / spacing).floor().isEven) ? 0.0 : spacing / 2;
      for (double x = spacing + rowOffset; x < maxX; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotTexturePainter old) =>
      old.color != color ||
      old.cutOffRight != cutOffRight ||
      old.spacing != spacing ||
      old.radius != radius;
}

class _LeafBranchPainter extends CustomPainter {
  final Color color;
  final double scale;

  const _LeafBranchPainter({required this.color, this.scale = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final stemPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * scale
      ..strokeCap = StrokeCap.round;

    final leafPaint = Paint()..color = color.withValues(alpha: 0.75);

    // Main curved stem from bottom-center to upper area
    final stem = Path()
      ..moveTo(size.width * 0.45, size.height * 0.98)
      ..quadraticBezierTo(
        size.width * 0.38,
        size.height * 0.55,
        size.width * 0.60,
        size.height * 0.15,
      );
    canvas.drawPath(stem, stemPaint);

    // Right-side leaves along the stem
    final rightLeaves = <Offset>[
      Offset(size.width * 0.52, size.height * 0.78),
      Offset(size.width * 0.56, size.height * 0.65),
      Offset(size.width * 0.60, size.height * 0.52),
      Offset(size.width * 0.62, size.height * 0.40),
      Offset(size.width * 0.60, size.height * 0.28),
    ];

    for (int i = 0; i < rightLeaves.length; i++) {
      final leafScale = (1.0 - i * 0.1) * scale;
      _drawLeaf(
        canvas,
        leafPaint,
        rightLeaves[i],
        14 * leafScale,
        -math.pi / 5,
      );
    }

    // Left-side leaves
    final leftLeaves = <Offset>[
      Offset(size.width * 0.46, size.height * 0.70),
      Offset(size.width * 0.48, size.height * 0.56),
      Offset(size.width * 0.52, size.height * 0.44),
    ];

    for (int i = 0; i < leftLeaves.length; i++) {
      final leafScale = (0.85 - i * 0.1) * scale;
      _drawLeaf(
        canvas,
        leafPaint,
        leftLeaves[i],
        12 * leafScale,
        math.pi - math.pi / 5,
      );
    }
  }

  void _drawLeaf(
    Canvas canvas,
    Paint paint,
    Offset center,
    double length,
    double angle,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(length * 0.45, -length * 0.45, length, 0)
      ..quadraticBezierTo(length * 0.45, length * 0.45, 0, 0);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LeafBranchPainter old) =>
      old.color != color || old.scale != scale;
}
