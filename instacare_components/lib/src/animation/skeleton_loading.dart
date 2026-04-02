import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/color.dart';

class InstaCareSkeletonLoading extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  const InstaCareSkeletonLoading({
    super.key,
    this.width,
    this.height = 14,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  Widget build(BuildContext context) {
    final indicatorColor = highlightColor ?? AppColors.primary700;
    final bgColor = baseColor ?? AppColors.gray50;

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
        ),
        child: Center(
          child: CupertinoActivityIndicator(
            color: indicatorColor,
            radius: (height * 0.32).clamp(6.0, 14.0),
          ),
        ),
      ),
    );
  }
}
