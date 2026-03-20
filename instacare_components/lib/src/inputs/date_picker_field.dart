import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareDatePickerField extends StatelessWidget {
  final String? label;
  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;
  final String hint;

  const InstaCareDatePickerField({
    super.key,
    this.label,
    this.value,
    this.onChanged,
    this.hint = 'mm/dd/yyyy',
  });

  @override
  Widget build(BuildContext context) {
    final text = value == null
        ? hint
        : '${value!.month.toString().padLeft(2, '0')}/${value!.day.toString().padLeft(2, '0')}/${value!.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: InstaCareTypography.r.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.gray800,
            ),
          ),
          const SizedBox(height: 8),
        ],
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            final now = DateTime.now();
            final selected = await showDatePicker(
              context: context,
              initialDate: value ?? now,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (selected != null) {
              onChanged?.call(selected);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.ivory300,
              suffixIcon: const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.gray600,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary700),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary700),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primary900,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              text,
              style: InstaCareTypography.r.copyWith(
                color: value == null ? AppColors.gray400 : AppColors.gray800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
