import 'package:flutter/material.dart';
import '../theme/color.dart';

class InstaCareShimmerSkeleton extends StatefulWidget {

  final double? width;
  final double height;
  final BorderRadiusGeometry? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;
  final BoxShape shape;
  final EdgeInsetsGeometry? margin;
  final bool enabled;
  final Widget? child;

  const InstaCareShimmerSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.shape = BoxShape.rectangle,
    this.margin,
    this.enabled = true,
    this.child,
  });

  /// Creates a circular shimmer skeleton (e.g., for avatars).
  factory InstaCareShimmerSkeleton.circle({
    Key? key,
    required double size,
    Color? baseColor,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
    EdgeInsetsGeometry? margin,
    bool enabled = true,
  }) {
    return InstaCareShimmerSkeleton(
      key: key,
      width: size,
      height: size,
      shape: BoxShape.circle,
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: duration,
      margin: margin,
      enabled: enabled,
    );
  }

  /// Creates a text-line shimmer skeleton.
  factory InstaCareShimmerSkeleton.text({
    Key? key,
    double? width,
    double height = 14,
    Color? baseColor,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
    EdgeInsetsGeometry? margin,
    bool enabled = true,
  }) {
    return InstaCareShimmerSkeleton(
      key: key,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(4),
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: duration,
      margin: margin,
      enabled: enabled,
    );
  }

  /// Creates a card-shaped shimmer skeleton.
  factory InstaCareShimmerSkeleton.card({
    Key? key,
    double? width,
    double height = 120,
    BorderRadiusGeometry? borderRadius,
    Color? baseColor,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
    EdgeInsetsGeometry? margin,
    bool enabled = true,
  }) {
    return InstaCareShimmerSkeleton(
      key: key,
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: duration,
      margin: margin,
      enabled: enabled,
    );
  }

  /// Creates a button-shaped shimmer skeleton.
  factory InstaCareShimmerSkeleton.button({
    Key? key,
    double? width,
    double height = 48,
    Color? baseColor,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
    EdgeInsetsGeometry? margin,
    bool enabled = true,
  }) {
    return InstaCareShimmerSkeleton(
      key: key,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(8),
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: duration,
      margin: margin,
      enabled: enabled,
    );
  }

  @override
  State<InstaCareShimmerSkeleton> createState() => _InstaCareShimmerSkeletonState();
}

class _InstaCareShimmerSkeletonState extends State<InstaCareShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(InstaCareShimmerSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? AppColors.gray200;
    final highlightColor = widget.highlightColor ?? AppColors.gray100;

    Widget skeleton = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          decoration: BoxDecoration(
            shape: widget.shape,
            borderRadius: widget.shape == BoxShape.circle 
                ? null 
                : (widget.borderRadius ?? BorderRadius.circular(8)),
            gradient: widget.enabled
                ? LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      baseColor,
                      highlightColor,
                      baseColor,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    transform: _SlideGradientTransform(_animation.value),
                  )
                : null,
            color: widget.enabled ? null : baseColor,
          ),
          child: widget.child,
        );
      },
    );

    return skeleton;
  }
}

/// Custom gradient transform for the shimmer effect.
class _SlideGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlideGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

/// A container widget that applies shimmer effect to multiple child skeletons.
/// 
/// Useful for creating complex loading layouts with multiple shimmer elements.
class InstaCareShimmerContainer extends StatelessWidget {
  /// Child widget containing skeleton elements.
  final Widget child;
  
  /// Whether the shimmer effect is enabled.
  final bool enabled;

  const InstaCareShimmerContainer({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
