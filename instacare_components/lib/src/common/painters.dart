import 'dart:math' as math;
import 'package:flutter/material.dart';

class DotTexturePainter extends CustomPainter {
  final Color color;
  final double cutOffRight;
  final double spacing;
  final double radius;

  const DotTexturePainter({
    required this.color,
    required this.cutOffRight,
    required this.spacing,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final maxX = size.width - cutOffRight;
    final startY = spacing + 4;
    final endY = size.height - spacing;

    for (double y = startY; y < endY; y += spacing) {
      final rowOffset = ((y / spacing).floor().isEven) ? 0.0 : spacing / 2;
      for (double x = spacing + rowOffset; x < maxX; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DotTexturePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.cutOffRight != cutOffRight ||
      oldDelegate.spacing != spacing ||
      oldDelegate.radius != radius;

  @override
  bool shouldRebuildSemantics(covariant DotTexturePainter oldDelegate) => false;
}

class LeafPainter extends CustomPainter {
  final Color color;

  const LeafPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final stemPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    final leafPaint = Paint()..color = color.withValues(alpha: 0.8);

    final stem = Path()
      ..moveTo(size.width * 0.48, size.height * 0.98)
      ..quadraticBezierTo(
        size.width * 0.42,
        size.height * 0.62,
        size.width * 0.62,
        size.height * 0.24,
      );
    canvas.drawPath(stem, stemPaint);

    final points = <Offset>[
      Offset(size.width * 0.57, size.height * 0.72),
      Offset(size.width * 0.63, size.height * 0.60),
      Offset(size.width * 0.66, size.height * 0.49),
      Offset(size.width * 0.64, size.height * 0.38),
      Offset(size.width * 0.58, size.height * 0.30),
    ];

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      final scale = 1 - (i * 0.08);
      _drawLeaf(canvas, leafPaint, p, 17 * scale, -math.pi / 6);
    }

    final leftPoints = <Offset>[
      Offset(size.width * 0.50, size.height * 0.64),
      Offset(size.width * 0.52, size.height * 0.52),
      Offset(size.width * 0.55, size.height * 0.42),
    ];

    for (int i = 0; i < leftPoints.length; i++) {
      final p = leftPoints[i];
      final scale = 0.9 - (i * 0.08);
      _drawLeaf(canvas, leafPaint, p, 15 * scale, -math.pi + (math.pi / 6));
    }
  }

  void _drawLeaf(
      Canvas canvas, Paint paint, Offset center, double length, double angle) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(length * 0.45, -length * 0.45, length, 0)
      ..quadraticBezierTo(length * 0.45, length * 0.45, 0, 0);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant LeafPainter oldDelegate) =>
      oldDelegate.color != color;

  @override
  bool shouldRebuildSemantics(covariant LeafPainter oldDelegate) => false;
}

class LeafBranchPainter extends CustomPainter {
  final Color color;
  final double scale;

  const LeafBranchPainter({required this.color, this.scale = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final stemPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * scale
      ..strokeCap = StrokeCap.round;

    final leafPaint = Paint()..color = color.withValues(alpha: 0.75);

    final stem = Path()
      ..moveTo(size.width * 0.45, size.height * 0.98)
      ..quadraticBezierTo(
        size.width * 0.38,
        size.height * 0.55,
        size.width * 0.60,
        size.height * 0.15,
      );
    canvas.drawPath(stem, stemPaint);

    final rightLeaves = <Offset>[
      Offset(size.width * 0.52, size.height * 0.78),
      Offset(size.width * 0.56, size.height * 0.65),
      Offset(size.width * 0.60, size.height * 0.52),
      Offset(size.width * 0.62, size.height * 0.40),
      Offset(size.width * 0.60, size.height * 0.28),
    ];

    for (int i = 0; i < rightLeaves.length; i++) {
      final leafScale = (1.0 - i * 0.1) * scale;
      _drawLeaf(
        canvas,
        leafPaint,
        rightLeaves[i],
        14 * leafScale,
        -math.pi / 5,
      );
    }

    final leftLeaves = <Offset>[
      Offset(size.width * 0.46, size.height * 0.70),
      Offset(size.width * 0.48, size.height * 0.56),
      Offset(size.width * 0.52, size.height * 0.44),
    ];

    for (int i = 0; i < leftLeaves.length; i++) {
      final leafScale = (0.85 - i * 0.1) * scale;
      _drawLeaf(
        canvas,
        leafPaint,
        leftLeaves[i],
        12 * leafScale,
        math.pi - math.pi / 5,
      );
    }
  }

  void _drawLeaf(
    Canvas canvas,
    Paint paint,
    Offset center,
    double length,
    double angle,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(length * 0.45, -length * 0.45, length, 0)
      ..quadraticBezierTo(length * 0.45, length * 0.45, 0, 0);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant LeafBranchPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.scale != scale;

  @override
  bool shouldRebuildSemantics(covariant LeafBranchPainter oldDelegate) => false;
}
