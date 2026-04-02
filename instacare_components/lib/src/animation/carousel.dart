import 'dart:async';

import 'package:flutter/material.dart';
import '../theme/color.dart';

class InstaCareCarousel extends StatefulWidget {
  final List<Widget> items;
  final double height;
  final Duration autoPlayDuration;
  final bool autoPlay;
  final bool showIndicators;
  final Color? indicatorActiveColor;
  final Color? indicatorInactiveColor;
  final EdgeInsetsGeometry? padding;
  final double viewportFraction;
  final ValueChanged<int>? onPageChanged;

  const InstaCareCarousel({
    super.key,
    required this.items,
    this.height = 200,
    this.autoPlayDuration = const Duration(seconds: 3),
    this.autoPlay = true,
    this.showIndicators = true,
    this.indicatorActiveColor,
    this.indicatorInactiveColor,
    this.padding,
    this.viewportFraction = 0.9,
    this.onPageChanged,
  });

  @override
  State<InstaCareCarousel> createState() => _InstaCareCarouselState();
}

class _InstaCareCarouselState extends State<InstaCareCarousel> {
  late PageController _pageController;
  Timer? _autoPlayTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: _currentPage,
    );

    if (widget.autoPlay && widget.items.length > 1) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(widget.autoPlayDuration, (_) {
      if (mounted && widget.autoPlay) {
        final nextPage = (_currentPage + 1) % widget.items.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              widget.onPageChanged?.call(index);
            },
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.15)).clamp(0.85, 1.0);
                  }
                  return Center(
                    child: SizedBox(
                      height: Curves.easeInOut.transform(value) * widget.height,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: widget.padding ??
                      const EdgeInsets.symmetric(horizontal: 8),
                  child: widget.items[index],
                ),
              );
            },
          ),
        ),
        if (widget.showIndicators && widget.items.length > 1) ...[
          const SizedBox(height: 16),
          _buildIndicators(),
        ],
      ],
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.items.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? (widget.indicatorActiveColor ?? AppColors.primary600)
                : (widget.indicatorInactiveColor ?? AppColors.gray400),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
