import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareSignaturePad extends StatefulWidget {
  final String label;
  final String clearLabel;
  final String confirmLabel;
  final String buttonLabel;
  final double height;
  final Color strokeColor;
  final double strokeWidth;
  final Color backgroundColor;
  final Color borderColor;
  final ValueChanged<List<List<Offset>>>? onChanged;
  final ValueChanged<List<List<Offset>>>? onConfirm;

  const InstaCareSignaturePad({
    super.key,
    this.label = 'Signature',
    this.clearLabel = 'Clear',
    this.confirmLabel = 'Confirm',
    this.buttonLabel = 'Tap to sign',
    this.height = 250,
    this.strokeColor = AppColors.gray800,
    this.strokeWidth = 2.0,
    this.backgroundColor = AppColors.baseWhite,
    this.borderColor = AppColors.primary200,
    this.onChanged,
    this.onConfirm,
  });

  @override
  State<InstaCareSignaturePad> createState() => InstaCareSignaturePadState();
}

class InstaCareSignaturePadState extends State<InstaCareSignaturePad> {
  List<List<Offset>> _confirmedStrokes = [];

  bool get isEmpty => _confirmedStrokes.isEmpty;

  void clear() {
    setState(() {
      _confirmedStrokes = [];
    });
    widget.onChanged?.call(_confirmedStrokes);
  }

  Future<ui.Image?> toImage() async {
    if (isEmpty) return null;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final painter = _SignaturePainter(
      strokes: _confirmedStrokes,
      currentStroke: null,
      strokeColor: widget.strokeColor,
      strokeWidth: widget.strokeWidth,
    );
    final size = Size(double.infinity, widget.height);
    painter.paint(canvas, size);
    final picture = recorder.endRecording();
    return picture.toImage(size.width.toInt(), size.height.toInt());
  }

  void _openSignaturePopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _SignaturePopupDialog(
          label: widget.label,
          clearLabel: widget.clearLabel,
          confirmLabel: widget.confirmLabel,
          height: widget.height,
          strokeColor: widget.strokeColor,
          strokeWidth: widget.strokeWidth,
          backgroundColor: widget.backgroundColor,
          borderColor: widget.borderColor,
          initialStrokes: List<List<Offset>>.from(
            _confirmedStrokes.map((s) => List<Offset>.from(s)),
          ),
          onConfirm: (strokes) {
            setState(() {
              _confirmedStrokes = strokes;
            });
            widget.onChanged?.call(_confirmedStrokes);
            widget.onConfirm?.call(_confirmedStrokes);
            Navigator.of(dialogContext).pop();
          },
          onCancel: () {
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: InstaCareTypography.m.copyWith(
            color: AppColors.gray800,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _openSignaturePopup,
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.borderColor, width: 1),
            ),
            child: isEmpty
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.draw_outlined,
                          color: AppColors.gray400,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.buttonLabel,
                          style: InstaCareTypography.r.copyWith(
                            color: AppColors.gray400,
                          ),
                        ),
                      ],
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: widget.height,
                        child: CustomPaint(
                          painter: _SignaturePainter(
                            strokes: _confirmedStrokes,
                            currentStroke: null,
                            strokeColor: widget.strokeColor,
                            strokeWidth: widget.strokeWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class _SignaturePopupDialog extends StatefulWidget {
  final String label;
  final String clearLabel;
  final String confirmLabel;
  final double height;
  final Color strokeColor;
  final double strokeWidth;
  final Color backgroundColor;
  final Color borderColor;
  final List<List<Offset>> initialStrokes;
  final ValueChanged<List<List<Offset>>> onConfirm;
  final VoidCallback onCancel;

  const _SignaturePopupDialog({
    required this.label,
    required this.clearLabel,
    required this.confirmLabel,
    required this.height,
    required this.strokeColor,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.borderColor,
    required this.initialStrokes,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<_SignaturePopupDialog> createState() => _SignaturePopupDialogState();
}

class _SignaturePopupDialogState extends State<_SignaturePopupDialog> {
  late List<List<Offset>> _strokes;
  List<Offset>? _currentStroke;

  bool get _isEmpty => _strokes.isEmpty && _currentStroke == null;

  @override
  void initState() {
    super.initState();
    _strokes = List<List<Offset>>.from(
      widget.initialStrokes.map((s) => List<Offset>.from(s)),
    );
  }

  void _clear() {
    setState(() {
      _strokes.clear();
      _currentStroke = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.label,
                  style: InstaCareTypography.m.copyWith(
                    color: AppColors.gray800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onCancel,
                  child: const Icon(Icons.close, color: AppColors.gray600),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Signature canvas
            Container(
              height: widget.height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: widget.borderColor, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (details) {
                    setState(() {
                      _currentStroke = [details.localPosition];
                    });
                  },
                  onPanUpdate: (details) {
                    if (_currentStroke != null) {
                      setState(() {
                        _currentStroke!.add(details.localPosition);
                      });
                    }
                  },
                  onPanEnd: (_) {
                    if (_currentStroke != null) {
                      setState(() {
                        _strokes.add(_currentStroke!);
                        _currentStroke = null;
                      });
                    }
                  },
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(double.infinity, widget.height),
                        painter: _SignaturePainter(
                          strokes: _strokes,
                          currentStroke: _currentStroke,
                          strokeColor: widget.strokeColor,
                          strokeWidth: widget.strokeWidth,
                        ),
                      ),
                      if (_isEmpty)
                        Center(
                          child: Text(
                            'Sign here',
                            style: InstaCareTypography.r.copyWith(
                              color: AppColors.gray400,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Confirm and Clear buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isEmpty ? null : _clear,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: _isEmpty ? AppColors.gray400 : AppColors.primary700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      widget.clearLabel,
                      style: InstaCareTypography.r.copyWith(
                        color: _isEmpty ? AppColors.gray400 : AppColors.primary700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isEmpty
                        ? null
                        : () => widget.onConfirm(_strokes),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary700,
                      disabledBackgroundColor: AppColors.gray300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      widget.confirmLabel,
                      style: InstaCareTypography.r.copyWith(
                        color: _isEmpty ? AppColors.gray400 : AppColors.baseWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset>? currentStroke;
  final Color strokeColor;
  final double strokeWidth;

  _SignaturePainter({
    required this.strokes,
    required this.currentStroke,
    required this.strokeColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final stroke in strokes) {
      _drawStroke(canvas, stroke, paint);
    }
    if (currentStroke != null) {
      _drawStroke(canvas, currentStroke!, paint);
    }
  }

  void _drawStroke(Canvas canvas, List<Offset> points, Paint paint) {
    if (points.isEmpty) return;
    if (points.length == 1) {
      canvas.drawPoints(ui.PointMode.points, points, paint);
      return;
    }
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
