import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareRadioOption<T> {
  final T value;
  final String label;

  const InstaCareRadioOption({required this.value, required this.label});
}

class InstaCareRadioButtons<T> extends StatelessWidget {
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final List<InstaCareRadioOption<T>> options;
  final Axis direction;

  const InstaCareRadioButtons({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.options,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final children = options
        .map(
          (option) => InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => onChanged(option.value),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: groupValue == option.value
                            ? Theme.of(context).colorScheme.primary
                            : AppColors.gray500,
                        width: 2,
                      ),
                    ),
                    child: groupValue == option.value
                        ? Center(
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    option.label,
                    style: InstaCareTypography.r.copyWith(
                      color: AppColors.gray800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();

    if (direction == Axis.horizontal) {
      return Wrap(spacing: 8, runSpacing: 4, children: children);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
