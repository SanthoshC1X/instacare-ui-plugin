import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareBottomNavItem {
  final IconData icon;
  final String label;

  const InstaCareBottomNavItem({required this.icon, required this.label});
}

class InstaCareBottomAppNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<InstaCareBottomNavItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Color? topBorderColor;
  final bool showShadow;

  const InstaCareBottomAppNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.topBorderColor,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedInnerBackground = backgroundColor ?? AppColors.primary900;
    final resolvedSelected = selectedItemColor ?? theme.colorScheme.primary;
    final resolvedUnselected = unselectedItemColor ?? AppColors.primary600;
    final resolvedBorder = topBorderColor ?? AppColors.primary900;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.baseWhite,
        border: Border(top: BorderSide(color: resolvedBorder)),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppColors.gray900.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: resolvedInnerBackground,
          selectedItemColor: resolvedSelected,
          unselectedItemColor: resolvedUnselected,
          selectedLabelStyle:
              InstaCareTypography.r.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              InstaCareTypography.r.copyWith(fontWeight: FontWeight.w500),
          items: items
              .map(
                (item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
