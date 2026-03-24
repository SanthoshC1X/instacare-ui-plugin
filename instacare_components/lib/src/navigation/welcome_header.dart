import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/input_theme.dart';
import '../theme/typography.dart';

class InstaCareWelcomeHeader extends StatelessWidget {
  final String userName;
  final String searchHint;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onAvatarTap;

  const InstaCareWelcomeHeader({
    super.key,
    required this.userName,
    this.searchHint = 'What care do you need today?',
    this.searchController,
    this.onSearchChanged,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: onAvatarTap,
              child: const CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.secondary500,
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 26,
                  color: AppColors.baseWhite,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Welcome, $userName',
                style: InstaCareTypography.h1.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray800,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          style: InstaCareTypography.r,
          decoration: InstaCareInputTheme.decoration(
            hintText: searchHint,
            hintStyle: InstaCareTypography.r.copyWith(
              color: AppColors.gray400,
            ),
            suffixIcon: const Icon(
              Icons.auto_awesome_outlined,
              size: 22,
              color: AppColors.secondary600,
            ),
            fillColor: AppColors.ivory200,
            borderColor: AppColors.secondary400,
          ),
        ),
      ],
    );
  }
}
