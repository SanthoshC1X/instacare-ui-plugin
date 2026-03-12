import 'package:flutter/material.dart';
import '../theme/color.dart';
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
                backgroundColor: AppColors.secondary5,
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
                  color: AppColors.gray2,
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
          decoration: InputDecoration(
            hintText: searchHint,
            hintStyle: InstaCareTypography.r.copyWith(
              color: AppColors.gray6,
            ),
            suffixIcon: const Icon(
              Icons.auto_awesome_outlined,
              size: 22,
              color: AppColors.secondary4,
            ),
            filled: true,
            fillColor: AppColors.ivory8,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.secondary6),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.secondary6),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary1,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
