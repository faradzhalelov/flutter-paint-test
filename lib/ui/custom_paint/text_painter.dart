import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomTextPainter extends CustomPainter {
  final List<Offset> points;
  final bool isEditMode;

  CustomTextPainter({
    super.repaint,
    required this.points,
    required this.isEditMode,
  });

  double _calculateDistance(Offset point1, Offset point2) {
    final dx = point2.dx - point1.dx;
    final dy = point2.dy - point1.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (isEditMode && points.length >= 2) {
      for (int i = 1; i < points.length; i++) {
        final startPoint = points[i - 1];
        final endPoint = points[i];
        final distance = _calculateDistance(startPoint, endPoint);
        final angle = math.atan2(
                endPoint.dy - startPoint.dy, endPoint.dx - startPoint.dx) +
            math.pi;

        final textPainter = TextPainter(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: distance.toStringAsFixed(2),
            style: const TextStyle(
                fontSize: 11, color: Colors.blue, fontWeight: FontWeight.w500),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        final textOffset = Offset(
          (startPoint.dx + endPoint.dx - textPainter.width) / 2,
          (startPoint.dy + endPoint.dy - textPainter.height) / 2,
        );
        final matrix4 = Matrix4.identity()
          ..translate(textOffset.dx, textOffset.dy)
          ..rotateZ(angle);
        final matrix = matrix4.storage;
        canvas.transform(matrix);
        textPainter.paint(canvas, Offset.zero);

        canvas.transform(Matrix4.inverted(matrix4).storage);
      }

      final startPoint = points.first;
      final endPoint = points.last;
      final distance = _calculateDistance(startPoint, endPoint);
      final angle =
          math.atan2(endPoint.dy - startPoint.dy, endPoint.dx - startPoint.dx) +
              math.pi;
      final textPainter = TextPainter(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: distance.toStringAsFixed(2),
          style: const TextStyle(
              fontSize: 11, color: Colors.blue, fontWeight: FontWeight.w500),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textOffset = Offset(
        (startPoint.dx + endPoint.dx - textPainter.width) / 2,
        (startPoint.dy + endPoint.dy - textPainter.height) / 2,
      );
      final matrix4 = Matrix4.identity()
        ..translate(textOffset.dx, textOffset.dy)
        ..rotateZ(angle);
      final matrix = matrix4.storage;
      canvas.transform(matrix);
      textPainter.paint(canvas, Offset.zero);

      canvas.transform(Matrix4.inverted(matrix4).storage);
    }
  }

  @override
  bool shouldRepaint(CustomTextPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.isEditMode != isEditMode;
}
