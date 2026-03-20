import 'package:flutter/material.dart';
import '../theme/color.dart';

class InstaCareSkeletonLoading extends StatefulWidget {
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
  State<InstaCareSkeletonLoading> createState() =>
      _InstaCareSkeletonLoadingState();
}

class _InstaCareSkeletonLoadingState extends State<InstaCareSkeletonLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.baseColor ?? AppColors.gray200;
    final highlight = widget.highlightColor ?? AppColors.baseWhite;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final slide = (_controller.value * 2) - 1;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment(slide - 1, 0),
              end: Alignment(slide + 1, 0),
              colors: [base, highlight, base],
              stops: const [0.2, 0.5, 0.8],
            ),
          ),
        );
      },
    );
  }
}
