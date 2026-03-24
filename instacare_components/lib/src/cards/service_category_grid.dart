import 'package:flutter/material.dart';
import '../common/painters.dart';
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
                child: ExcludeSemantics(
                  child: CustomPaint(
                    painter: DotTexturePainter(
                      color: AppColors.baseWhite.withValues(alpha: 0.09),
                      cutOffRight: leafWidth,
                      spacing: 10,
                      radius: 0.8,
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
                    painter: LeafBranchPainter(
                      color:
                          AppColors.serviceCardAccent.withValues(alpha: 0.7),
                      scale: h / 120,
                    ),
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
                  : ExcludeSemantics(
                      child: CustomPaint(
                        size: const Size(120, 120),
                        painter: LeafBranchPainter(
                          color: AppColors.serviceCardAccent
                              .withValues(alpha: 0.85),
                          scale: 1.2,
                        ),
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
