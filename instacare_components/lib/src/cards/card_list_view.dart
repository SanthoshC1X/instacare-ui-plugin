import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareCardListItem {
  final Widget card;
  final String title;
  final String body;

  const InstaCareCardListItem({
    required this.card,
    required this.title,
    required this.body,
  });
}

class InstaCareCardListView extends StatelessWidget {
  final List<InstaCareCardListItem> items;
  final double spacing;
  final double cardWidth;

  const InstaCareCardListView({
    super.key,
    required this.items,
    this.spacing = 12,
    this.cardWidth = 84,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center, // ✅ FIX
            children: [
              SizedBox(
                width: cardWidth,
                child: Center( // ✅ ensures visual centering
                  child: items[i].card,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // ✅
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      items[i].title,
                      style: InstaCareTypography.r.copyWith(
                        color: AppColors.gray800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items[i].body,
                      style: InstaCareTypography.r.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (i < items.length - 1) SizedBox(height: spacing),
        ],
      ],
    );
  }
}
