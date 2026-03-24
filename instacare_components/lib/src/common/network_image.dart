import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../animation/skeleton_loading.dart';

/// Lightweight network image wrapper for the design system.
///
/// Handles: placeholder shimmer, fade-in animation, error fallback,
/// border radius, and sizing. Uses Flutter's built-in memory cache.
///
/// For disk caching, the consuming app can provide a custom [imageBuilder]
/// that wraps cached_network_image or any other caching package.
class InstaCareNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration fadeInDuration;
  final Color? backgroundColor;

  /// Optional custom image builder — lets the main app inject its own
  /// caching implementation (e.g. CachedNetworkImage) while keeping
  /// the same UI contract (placeholder, error, border radius).
  final Widget Function(BuildContext context, String url)? imageBuilder;

  const InstaCareNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.backgroundColor,
    this.imageBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        width: width,
        height: height,
        color: backgroundColor ?? AppColors.gray100,
        child: imageBuilder != null
            ? imageBuilder!(context, imageUrl)
            : _buildDefaultImage(),
      ),
    );
  }

  Widget _buildDefaultImage() {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedSwitcher(
          duration: fadeInDuration,
          child: frame != null
              ? child
              : _buildPlaceholder(),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildPlaceholder();
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildError();
      },
    );
  }

  Widget _buildPlaceholder() {
    return placeholder ??
        InstaCareSkeletonLoading(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          borderRadius: borderRadius,
        );
  }

  Widget _buildError() {
    return errorWidget ??
        Center(
          child: Icon(
            Icons.broken_image_outlined,
            color: AppColors.gray400,
            size: (height != null && height! < 40) ? 16 : 24,
          ),
        );
  }
}
