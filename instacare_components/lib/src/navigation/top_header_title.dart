import 'package:flutter/material.dart';
import '../theme/typography.dart';
import '../theme/color.dart';

class InstaCareTopHeaderTitle extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  const InstaCareTopHeaderTitle({
    super.key,
    required this.title,
    this.actions,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: InstaCareTypography.h2.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.gray2,
        ),
      ),
      leading: onBack == null ? null : IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: onBack),
      actions: actions,
    );
  }
}

