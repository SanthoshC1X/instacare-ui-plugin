import 'package:flutter/material.dart';
import '../theme/color.dart';

class InstaCareRatingScale extends StatelessWidget {
  final int maxRating;
  final int currentRating;
  final ValueChanged<int> onRatingChanged;

  const InstaCareRatingScale({
    super.key,
    this.maxRating = 5,
    required this.currentRating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(maxRating, (index) {
        final ratingValue = index + 1;
        final isFilled = ratingValue <= currentRating;
        return IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () => onRatingChanged(ratingValue),
          icon: Icon(
            isFilled ? Icons.star : Icons.star_border,
            color: isFilled ? AppColors.secondary800 : AppColors.gray400,
          ),
        );
      }),
    );
  }
}
