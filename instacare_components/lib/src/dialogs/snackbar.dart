import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';
import '../types/feedback_type.dart';

@Deprecated('Use InstaCareFeedbackType instead')
typedef InstaCareSnackbarType = InstaCareFeedbackType;

class InstaCareSnackbar {
  static void show({
    required BuildContext context,
    required InstaCareFeedbackType type,
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onClose,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _InstaCareSnackbarWidget(
        type: type,
        title: title,
        message: message,
        onClose: () {
          overlayEntry.remove();
          onClose?.call();
        },
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}

class _InstaCareSnackbarWidget extends StatefulWidget {
  final InstaCareFeedbackType type;
  final String title;
  final String message;
  final VoidCallback onClose;

  const _InstaCareSnackbarWidget({
    required this.type,
    required this.title,
    required this.message,
    required this.onClose,
  });

  @override
  State<_InstaCareSnackbarWidget> createState() =>
      _InstaCareSnackbarWidgetState();
}

class _InstaCareSnackbarWidgetState extends State<_InstaCareSnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData get _icon {
    switch (widget.type) {
      case InstaCareFeedbackType.info:
        return Icons.info_outline;
      case InstaCareFeedbackType.error:
        return Icons.error_outline;
      case InstaCareFeedbackType.pending:
        return Icons.hourglass_top;
      case InstaCareFeedbackType.success:
        return Icons.check_circle_outline;
    }
  }

  Color _backgroundColor() {
    switch (widget.type) {
      case InstaCareFeedbackType.info:
        return AppColors.infoBg;
      case InstaCareFeedbackType.error:
        return AppColors.errorBg;
      case InstaCareFeedbackType.pending:
        return AppColors.warningBg;
      case InstaCareFeedbackType.success:
        return AppColors.successBg;
    }
  }

  Color _foregroundColor() {
    switch (widget.type) {
      case InstaCareFeedbackType.info:
        return AppColors.infoFg;
      case InstaCareFeedbackType.error:
        return AppColors.errorFg;
      case InstaCareFeedbackType.pending:
        return AppColors.warningFg;
      case InstaCareFeedbackType.success:
        return AppColors.successFg;
    }
  }

  void _handleClose() async {
    await _controller.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final fg = _foregroundColor();

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _backgroundColor(),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gray400.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(_icon, size: 24, color: fg),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          style: InstaCareTypography.r.copyWith(
                            fontWeight: FontWeight.w700,
                            color: fg,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.message,
                          style: InstaCareTypography.r.copyWith(color: fg),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _handleClose,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: fg,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
