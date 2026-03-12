import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareSignaturePad extends StatefulWidget {
  final String label;
  final String clearLabel;
  final double height;
  final Color strokeColor;
  final double strokeWidth;
  final Color backgroundColor;
  final Color borderColor;
  final ValueChanged<List<List<Offset>>>? onChanged;

  const InstaCareSignaturePad({
    super.key,
    this.label = 'Signature',
    this.clearLabel = 'Clear',
    this.height = 200,
    this.strokeColor = AppColors.gray2,
    this.strokeWidth = 2.0,
    this.backgroundColor = AppColors.baseWhite,
    this.borderColor = AppColors.primary8,
    this.onChanged,
  });

  @override
  State<InstaCareSignaturePad> createState() => InstaCareSignaturePadState();
}

class InstaCareSignaturePadState extends State<InstaCareSignaturePad> {
  final List<List<Offset>> _strokes = [];
  List<Offset>? _currentStroke;

  bool get isEmpty => _strokes.isEmpty && _currentStroke == null;

  void clear() {
    setState(() {
      _strokes.clear();
      _currentStroke = null;
    });
    widget.onChanged?.call(_strokes);
  }

  Future<ui.Image?> toImage() async {
    if (isEmpty) return null;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final painter = _SignaturePainter(
      strokes: _strokes,
      currentStroke: null,
      strokeColor: widget.strokeColor,
      strokeWidth: widget.strokeWidth,
    );
    final size = Size(double.infinity, widget.height);
    painter.paint(canvas, size);
    final picture = recorder.endRecording();
    return picture.toImage(size.width.toInt(), size.height.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: InstaCareTypography.m.copyWith(
                color: AppColors.gray2,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: isEmpty ? null : clear,
              child: Text(
                widget.clearLabel,
                style: InstaCareTypography.sm.copyWith(
                  color: isEmpty ? AppColors.gray6 : AppColors.primary3,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
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
              onPanDown: (_) {
                // Disable parent scrolling while signing
                final scrollable = Scrollable.maybeOf(context);
                scrollable?.position.hold(() {});
              },
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
                  widget.onChanged?.call(_strokes);
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
                  if (isEmpty)
                    Center(
                      child: Text(
                        'Sign here',
                        style: InstaCareTypography.r.copyWith(
                          color: AppColors.gray6,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
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
