import 'dart:ui';
import 'package:flutter/material.dart';

class CameraGridPainter extends CustomPainter {
  final double rotationAngle;
  final double morphProgress;
  final Color gridColor;
  final Color accentColor;
  final double gridLineWidth;
  final double movingBorderRadius;
  final bool isSnapped;
  final double snapThreshold;

  CameraGridPainter({
    required this.rotationAngle,
    required this.morphProgress,
    required this.gridColor,
    required this.accentColor,
    required this.isSnapped,
    required this.snapThreshold,
    this.gridLineWidth = 1.0,
    this.movingBorderRadius = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);
    _drawAlignmentBox(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = gridLineWidth;

    for (int i = 1; i < 3; i++) {
      double x = (size.width / 3) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (int i = 1; i < 3; i++) {
      double y = (size.height / 3) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawAlignmentBox(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final portraitWidth = size.width / 3;
    final portraitHeight = size.height / 3;
    final landscapeWidth = size.height / 3;
    final landscapeHeight = size.width / 3;

    final boxWidth = lerpDouble(portraitWidth, landscapeWidth, morphProgress)!;
    final boxHeight =
        lerpDouble(portraitHeight, landscapeHeight, morphProgress)!;

    double borderRadius = isSnapped ? 0 : movingBorderRadius;
    Color borderColor = Color.lerp(gridColor, accentColor, isSnapped ? 1 : 0)!;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = gridLineWidth;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationAngle);

    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: boxWidth, height: boxHeight),
      Radius.circular(borderRadius),
    );
    canvas.drawRRect(rrect, boxPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CameraGridPainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.morphProgress != morphProgress ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.gridLineWidth != gridLineWidth ||
        oldDelegate.movingBorderRadius != movingBorderRadius ||
        oldDelegate.isSnapped != isSnapped ||
        oldDelegate.snapThreshold != snapThreshold;
  }
}
