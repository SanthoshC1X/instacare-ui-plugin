import 'package:flutter/material.dart';
import '../buttons/button.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareMcqOptionSelector extends StatelessWidget {
  final String question;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;
  final String previousLabel;
  final String nextLabel;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const InstaCareMcqOptionSelector({
    super.key,
    required this.question,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.previousLabel,
    required this.nextLabel,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite ? constraints.maxWidth : 320.0;
        final dotOuter = (width * 0.06).clamp(18.0, 22.0);
        final dotInner = (dotOuter * 0.42).clamp(7.0, 9.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: InstaCareTypography.h3.copyWith(color: AppColors.gray800),
            ),
            const SizedBox(height: 18),
            ...options.map(
              (option) {
                final isSelected = selected == option;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => onSelected(option),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? Theme.of(context).colorScheme.primary : AppColors.primary300,
                          width: 1.4,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: dotOuter,
                            height: dotOuter,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? Theme.of(context).colorScheme.primary : AppColors.primary800,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      height: dotInner,
                                      width: dotInner,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              option,
                              style: InstaCareTypography.r.copyWith(color: AppColors.gray800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InstaCareButton.secondary(
                    text: previousLabel,
                    onPressed: onPrevious,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InstaCareButton(
                    text: nextLabel,
                    onPressed: onNext,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}


