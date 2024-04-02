
//TODO:
// import 'package:flutter/material.dart';
// import 'dart:ui';

// import 'package:paint_gpt/model/canvas_state.dart';

// class InfiniteCanvasPage extends StatefulWidget {
//   const InfiniteCanvasPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _InfiniteCanvasPageState createState() => _InfiniteCanvasPageState();
// }

// class _InfiniteCanvasPageState extends State<InfiniteCanvasPage> {
//   List<Offset?> points = [];
//   CanvasState canvasState = CanvasState.draw;
//   Offset offset = Offset(0, 0);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         child: Text(canvasState == CanvasState.draw ? "Draw" : "Pan"),
//         backgroundColor:
//             canvasState == CanvasState.draw ? Colors.red : Colors.blue,
//         onPressed: () {
//           setState(() {
//             canvasState = canvasState == CanvasState.draw
//                 ? CanvasState.pan
//                 : CanvasState.draw;
//           });
//         },
//       ),
//       body: GestureDetector(
//         onPanDown: (details) {
//           setState(() {
//             if (canvasState == CanvasState.draw) {
//               points.add(details.localPosition - offset);
//             }
//           });
//         },
//         onPanUpdate: (details) {
//           setState(() {
//             if (canvasState == CanvasState.pan) {
//               offset += details.delta;
//             } else {
//               points.add(details.localPosition - offset);
//             }
//           });
//         },
//         onPanEnd: (details) {
//           setState(() {
//             if (canvasState == CanvasState.draw) {
//               points.add(null);
//             }
//           });
//         },
//         child: SizedBox.expand(
//           child: ClipRRect(
//             child: CustomPaint(
//               painter: CanvasCustomPainter(points: points, offset: offset),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CanvasCustomPainter extends CustomPainter {
//   List<Offset?> points;
//   Offset offset;

//   CanvasCustomPainter({required this.points, required this.offset});

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint background = Paint()..color = Colors.white;

//     Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

//     canvas.drawRect(rect, background);
//     canvas.clipRect(rect);

//     Paint drawingPaint = Paint()
//       ..strokeCap = StrokeCap.round
//       ..isAntiAlias = true
//       ..color = Colors.black
//       ..strokeWidth = 1.5;

//     for (int x = 0; x < points.length - 1; x++) {
//       if (points[x] != null && points[x + 1] != null) {
//         canvas.drawLine(
//             points[x]! + offset, points[x + 1]! + offset, drawingPaint);
//       }
//       else if (points[x] != null && points[x + 1] == null) {
//         canvas.drawPoints(
//             PointMode.points, [points[x]! + offset], drawingPaint);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(CanvasCustomPainter oldDelegate) {
//     return true;
//   }
// }
