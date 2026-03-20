import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareServiceListItem {
  final String name;
  final String duration;
  final String price;
  final String description;
  final bool isNew;
  final ImageProvider? image;

  const InstaCareServiceListItem({
    required this.name,
    required this.duration,
    required this.price,
    required this.description,
    this.isNew = false,
    this.image,
  });
}

class InstaCareServiceListTile extends StatelessWidget {
  final List<InstaCareServiceListItem> items;
  final String newBadgeLabel;
  final ValueChanged<InstaCareServiceListItem>? onItemTap;

  const InstaCareServiceListTile({
    super.key,
    required this.items,
    this.newBadgeLabel = 'New',
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _ServiceTile(
            item: items[i],
            newBadgeLabel: newBadgeLabel,
            onTap: () => onItemTap?.call(items[i]),
          ),
          if (i < items.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final InstaCareServiceListItem item;
  final String newBadgeLabel;
  final VoidCallback? onTap;

  const _ServiceTile({
    required this.item,
    required this.newBadgeLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.natural50,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.gray300.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item.image != null
                  ? Image(
                      image: item.image!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: AppColors.primary100,
                      child: const Icon(
                        Icons.medical_services_outlined,
                        size: 36,
                        color: AppColors.primary500,
                      ),
                    ),
            ),
            const SizedBox(width: 14),
            // Text content section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: InstaCareTypography.m.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.gray800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.isNew) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.ivory900,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            newBadgeLabel,
                            style: InstaCareTypography.xs.copyWith(
                              color: AppColors.ivory900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: AppColors.gray500,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${item.duration} | ${item.price}',
                          style: InstaCareTypography.s.copyWith(
                            color: AppColors.gray700,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: InstaCareTypography.s.copyWith(
                      color: AppColors.gray500,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
