import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

enum InstaCareSnackbarType { info, error, pending, success }

class InstaCareSnackbar {
  static void show({
    required BuildContext context,
    required InstaCareSnackbarType type,
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
  final InstaCareSnackbarType type;
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
  
  double _dragOffset = 0.0;
  bool _isDragging = false;

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
      case InstaCareSnackbarType.info:
        return Icons.info_outline;
      case InstaCareSnackbarType.error:
        return Icons.error_outline;
      case InstaCareSnackbarType.pending:
        return Icons.hourglass_top;
      case InstaCareSnackbarType.success:
        return Icons.check_circle_outline;
    }
  }

  Color _backgroundColor() {
    switch (widget.type) {
      case InstaCareSnackbarType.info:
        return AppColors.infoBg;
      case InstaCareSnackbarType.error:
        return AppColors.errorBg;
      case InstaCareSnackbarType.pending:
        return AppColors.warningBg;
      case InstaCareSnackbarType.success:
        return AppColors.successBg;
    }
  }

  Color _foregroundColor() {
    switch (widget.type) {
      case InstaCareSnackbarType.info:
        return AppColors.infoFg;
      case InstaCareSnackbarType.error:
        return AppColors.errorFg;
      case InstaCareSnackbarType.pending:
        return AppColors.warningFg;
      case InstaCareSnackbarType.success:
        return AppColors.successFg;
    }
  }

  void _handleClose() async {
    await _controller.reverse();
    widget.onClose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;
    
    setState(() {
      // Only allow upward swipes (negative delta)
      _dragOffset += details.delta.dy;
      _dragOffset = _dragOffset.clamp(double.negativeInfinity, 0.0);
    });
  }

  void _onPanStart(DragStartDetails details) {
    _isDragging = true;
  }

  void _onPanEnd(DragEndDetails details) {
    _isDragging = false;
    
    // If dragged up more than 50 pixels or with sufficient velocity, dismiss
    if (_dragOffset < -50 || details.velocity.pixelsPerSecond.dy < -300) {
      _handleClose();
    } else {
      // Snap back to original position
      setState(() {
        _dragOffset = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fg = _foregroundColor();

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16 + _dragOffset,
      left: 16,
      right: 16,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
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
      ),
    );
  }
}
