import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final List<Offset> points;
  final bool isEditMode;
  final Offset panOffset;
  final Offset startPoint;
  final Offset endPoint;

  DrawingPainter(this.points, this.isEditMode,
      {required this.panOffset,
      required this.startPoint,
      required this.endPoint});

  // bool checkLineIntersection(Offset p1, Offset p2, Offset p3, Offset p4) {
  //   final x1 = p1.dx;
  //   final y1 = p1.dy;
  //   final x2 = p2.dx;
  //   final y2 = p2.dy;
  //   final x3 = p3.dx;
  //   final y3 = p3.dy;
  //   final x4 = p4.dx;
  //   final y4 = p4.dy;

  //   final d = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
  //   if (d == 0) {
  //     return false;
  //   }

  //   final pre = (x1 * y2 - y1 * x2);
  //   final post = (x3 * y4 - y3 * x4);
  //   final px = (pre * (x3 - x4) - (x1 - x2) * post) / d;
  //   final py = (pre * (y3 - y4) - (y1 - y2) * post) / d;

  //   if (px < math.min(x1, x2) ||
  //       px > math.max(x1, x2) ||
  //       px < math.min(x3, x4) ||
  //       px > math.max(x3, x4)) {
  //     return false;
  //   }
  //   if (py < math.min(y1, y2) ||
  //       py > math.max(y1, y2) ||
  //       py < math.min(y3, y4) ||
  //       py > math.max(y3, y4)) {
  //     return false;
  //   }

  //   return true;
  // }

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 7.0;

    final dotsPaint = Paint()
      ..color = isEditMode ? Colors.white : Colors.blue
      ..style = PaintingStyle.fill;

    final dotsBackPaint = Paint()
      ..color = isEditMode ? Colors.grey : Colors.white
      ..style = PaintingStyle.fill;

    final polygonPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    if (!isEditMode && (startPoint != Offset.zero || endPoint != Offset.zero)) {
      //bool isIntersection = false;
      // if (points.length > 2) {
      //   final p1 = points.last;
      //   final p2 = points[points.length - 2];
      //   isIntersection = checkLineIntersection(endPoint, endPoint, p1, p2);
      // }
      final tempPaint = Paint()
        ..color = Colors.black
        ..strokeWidth = 7.0;
      final tempBgDotsPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      final tempDotsPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;

      canvas.drawLine(startPoint, endPoint, tempPaint);
      canvas.drawCircle(startPoint, 7, tempBgDotsPaint);
      canvas.drawCircle(startPoint, 5, tempDotsPaint);
      canvas.drawCircle(endPoint, 7, tempBgDotsPaint);
      canvas.drawCircle(endPoint, 5, tempDotsPaint);
    }

    if (points.isNotEmpty) {
      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      if (isEditMode && points.length > 2) {
        path.lineTo(points.first.dx, points.first.dy);
        canvas.drawPath(path, polygonPaint);
        canvas.drawPath(path, linePaint);
      } else {
        canvas.drawPath(path, linePaint);
      }
    }

    for (final point in points) {
      canvas.drawCircle(point, 7, dotsBackPaint);
      canvas.drawCircle(point, isEditMode ? 6 : 5, dotsPaint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.startPoint != startPoint ||
        oldDelegate.endPoint != endPoint ||
        oldDelegate.panOffset != panOffset ||
        oldDelegate.points != points ||
        oldDelegate.isEditMode != isEditMode;
  }
}
