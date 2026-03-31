import 'package:flutter/material.dart';
import 'shimmer_skeleton.dart';

class InstaCareSkeletonLayouts {
  InstaCareSkeletonLayouts._();
  static Widget listItem({
    bool showAvatar = true,
    bool showSubtitle = true,
    EdgeInsetsGeometry? padding,
  }) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar) ...[
            InstaCareShimmerSkeleton.circle(size: 48),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InstaCareShimmerSkeleton.text(
                  width: double.infinity,
                  height: 16,
                ),
                if (showSubtitle) ...[
                  const SizedBox(height: 8),
                  InstaCareShimmerSkeleton.text(
                    width: 200,
                    height: 14,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card skeleton with image and text content.
  static Widget card({
    double? width,
    double imageHeight = 160,
    bool showImage = true,
    int textLines = 2,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: width,
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showImage) ...[
            InstaCareShimmerSkeleton.card(
              width: double.infinity,
              height: imageHeight,
            ),
            const SizedBox(height: 12),
          ],
          ...List.generate(
            textLines,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: index < textLines - 1 ? 8 : 0),
              child: InstaCareShimmerSkeleton.text(
                width: index == textLines - 1 ? 150 : double.infinity,
                height: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Profile header skeleton with avatar and info.
  static Widget profileHeader({
    EdgeInsetsGeometry? padding,
  }) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        children: [
          InstaCareShimmerSkeleton.circle(size: 80),
          const SizedBox(height: 16),
          InstaCareShimmerSkeleton.text(
            width: 120,
            height: 18,
          ),
          const SizedBox(height: 8),
          InstaCareShimmerSkeleton.text(
            width: 180,
            height: 14,
          ),
        ],
      ),
    );
  }

  /// Form field skeleton.
  static Widget formField({
    bool showLabel = true,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLabel) ...[
            InstaCareShimmerSkeleton.text(
              width: 100,
              height: 14,
            ),
            const SizedBox(height: 8),
          ],
          InstaCareShimmerSkeleton(
            width: double.infinity,
            height: 48,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }

  /// Booking card skeleton.
  static Widget bookingCard({
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InstaCareShimmerSkeleton(
        width: double.infinity,
        height: 140,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: InstaCareShimmerSkeleton.text(
                      width: double.infinity,
                      height: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  InstaCareShimmerSkeleton(
                    width: 60,
                    height: 24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              InstaCareShimmerSkeleton.text(
                width: 180,
                height: 14,
              ),
              const SizedBox(height: 8),
              InstaCareShimmerSkeleton.text(
                width: 140,
                height: 14,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InstaCareShimmerSkeleton.text(
                    width: 100,
                    height: 14,
                  ),
                  InstaCareShimmerSkeleton(
                    width: 80,
                    height: 32,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Service card skeleton (grid item).
  static Widget serviceCard({
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      margin: margin ?? const EdgeInsets.all(8),
      child: Column(
        children: [
          InstaCareShimmerSkeleton.card(
            width: double.infinity,
            height: 100,
          ),
          const SizedBox(height: 8),
          InstaCareShimmerSkeleton.text(
            width: double.infinity,
            height: 14,
          ),
        ],
      ),
    );
  }

  /// Grid layout skeleton.
  static Widget grid({
    int crossAxisCount = 2,
    int itemCount = 6,
    double childAspectRatio = 1.0,
    EdgeInsetsGeometry? padding,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding ?? const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => serviceCard(margin: EdgeInsets.zero),
    );
  }

  /// List layout skeleton.
  static Widget list({
    int itemCount = 5,
    bool showAvatar = true,
    bool showSubtitle = true,
    EdgeInsetsGeometry? padding,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding ?? EdgeInsets.zero,
      itemCount: itemCount,
      itemBuilder: (context, index) => listItem(
        showAvatar: showAvatar,
        showSubtitle: showSubtitle,
      ),
    );
  }
}
