import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareStepperItem {
  final String title;
  final String? description;

  const InstaCareStepperItem({
    required this.title,
    this.description,
  });
}

class InstaCareVerticalStepper extends StatefulWidget {
  final List<InstaCareStepperItem> items;
  final int currentStep;
  final ValueChanged<int>? onStepChanged;
  final Duration animationDuration;

  const InstaCareVerticalStepper({
    super.key,
    required this.items,
    required this.currentStep,
    this.onStepChanged,
    this.animationDuration = const Duration(milliseconds: 600),
  });

  @override
  State<InstaCareVerticalStepper> createState() => _InstaCareVerticalStepperState();
}

class _InstaCareVerticalStepperState extends State<InstaCareVerticalStepper>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    final connectorCount =
        widget.items.isEmpty ? 0 : widget.items.length - 1;

    _controllers = List.generate(
      connectorCount,
      (index) => AnimationController(
        vsync: this,
        duration: widget.animationDuration,
        value: index < widget.currentStep ? 1.0 : 0.0,
      ),
    );

    _animations = _controllers
        .map((controller) => CurvedAnimation(
              parent: controller,
              curve: Curves.easeInOut,
            ))
        .toList();
  }

  @override
  void didUpdateWidget(InstaCareVerticalStepper oldWidget) {
    super.didUpdateWidget(oldWidget);

    final shouldReinitialize = oldWidget.items.length != widget.items.length ||
        oldWidget.animationDuration != widget.animationDuration;

    if (shouldReinitialize) {
      _disposeControllers();
      _initializeAnimations();
    }

    if (oldWidget.currentStep != widget.currentStep || shouldReinitialize) {
      _updateAnimations();
    }
  }

  void _updateAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      if (i < widget.currentStep) {
        _controllers[i].forward();
      } else {
        _controllers[i].reverse();
      }
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    for (final controller in _controllers) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            constraints.maxWidth.isFinite ? constraints.maxWidth : 360.0;

        final circleSize = (width / (widget.items.length * 4)).clamp(30.0, 40.0);
        final stepNumberSize = (circleSize * 0.45).clamp(12.0, 16.0);

        const primary = AppColors.primary900;
        const inactive = AppColors.primary200;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int index = 0; index < widget.items.length; index++) ...[
              // Circle + label stacked
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => widget.onStepChanged?.call(index),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index <= widget.currentStep ? primary : inactive,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: InstaCareTypography.sm.copyWith(
                          color: AppColors.baseWhite,
                          fontSize: stepNumberSize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Step ${index + 1}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: index <= widget.currentStep
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: index <= widget.currentStep ? primary : inactive,
                    ),
                  ),
                ],
              ),
              // Connector line between circles
              if (index < widget.items.length - 1)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: circleSize / 2 - 1,
                      left: 6,
                      right: 6,
                    ),
                    child: _AnimatedConnector(
                      animation: _animations[index],
                      activeColor: primary,
                      inactiveColor: inactive,
                      isCompleted: index < widget.currentStep,
                      showArrow: false,
                    ),
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}

class _AnimatedConnector extends StatelessWidget {
  final Animation<double> animation;
  final Color activeColor;
  final Color inactiveColor;
  final bool isCompleted;
  final bool showArrow;

  const _AnimatedConnector({
    required this.animation,
    required this.activeColor,
    required this.inactiveColor,
    required this.isCompleted,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background (inactive) line
          Container(
            height: 2,
            color: inactiveColor,
          ),
          // Animated (active) line
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: animation.value,
                  child: Container(
                    height: 2,
                    color: activeColor,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
