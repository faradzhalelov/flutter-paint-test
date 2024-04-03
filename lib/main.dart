import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paint_gpt/utils/utils.dart';

import 'providers/providers.dart';
import 'ui/custom_paint/draw_painter.dart';
import 'ui/custom_paint/text_painter.dart';
import 'ui/widgets/custom_toogle_button.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final points = ref.watch(pointsProvider);
    final isEditMode = ref.watch(modeProvider);
    final startPoint = ref.watch(startPointProvider);
    final endPoint = ref.watch(endPointProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: CustomTextPainter(
                        points: points,
                        isEditMode: isEditMode,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: GestureDetector(
                      onTapDown: isEditMode && points.length >= 3
                          ? (details) {
                              final offset = details.localPosition;

                              for (int i = 0; i < points.length; i++) {
                                final point = points[i];
                                final distance = math.sqrt(
                                    math.pow(point.dx - offset.dx, 2) +
                                        math.pow(point.dy - offset.dy, 2));
                                if (distance < 10.0) {
                                  ref
                                      .read(selectedPointIndexProvider.notifier)
                                      .update((state) => i);
                                  break;
                                }
                              }
                            }
                          : null,
                      onPanStart: (details) =>
                          onPanStart(details.localPosition, ref),
                      onPanUpdate: (details) =>
                          onPanUpdate(details.localPosition, ref),
                      onPanEnd: (details) => onPanEnd(ref),
                      child: CustomPaint(
                        painter: DrawingPainter(
                          startPoint: startPoint,
                          endPoint: endPoint,
                          points,
                          isEditMode,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 16,
                      left: 8,
                      child: CustomToogleButton(
                        onUndo: () => onUndo(ref),
                        onRedo: () => onRedo(ref),
                      )),
                  Positioned(
                    top: 12,
                    left: 130,
                    child: IconButton(
                      onPressed: () {
                        onClear(ref);
                        ref
                            .read(modeProvider.notifier)
                            .update((state) => false);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: iconColor,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void onClear(WidgetRef ref) {
    ref.read(pointsProvider.notifier).update((state) => []);
    ref.read(undoStackProvider.notifier).update((state) => []);
    ref.read(redoStackProvider.notifier).update((state) => []);
  }

  void onPanEnd(WidgetRef ref) {
    log('PAN END');
    final isEditMode = ref.read(modeProvider);
    final points = ref.read(pointsProvider);
    if (!isEditMode) {
      ref.read(undoStackProvider.notifier).state.add([...points]);
      ref.read(redoStackProvider.notifier).update((state) => []);
      final updatePoints = points;
      final startPoint = ref.read(startPointProvider);
      final endPoint = ref.read(endPointProvider);

      if (points.isEmpty) {
        updatePoints.add(startPoint);
      }

      updatePoints.add(endPoint);
      ref.read(pointsProvider.notifier).update((state) => updatePoints);
    }

    ref.read(selectedPointIndexProvider.notifier).update((state) => null);
    ref.read(startPointProvider.notifier).update((state) => Offset.zero);
    ref.read(endPointProvider.notifier).update((state) => Offset.zero);

    if (!isEditMode && points.length > 2) {
      final firstPoint = points.first;
      final lastPoint = points.last;

      final distance = math.sqrt(math.pow(firstPoint.dx - lastPoint.dx, 2) +
          math.pow(firstPoint.dy - lastPoint.dy, 2));
      if (distance < 200.0) {
        ref.read(modeProvider.notifier).update((state) => true);
      }
    }
  }

  void onPanStart(Offset details, WidgetRef ref) {
    final points = ref.read(pointsProvider);

    if (!ref.read(modeProvider)) {
      if (points.isNotEmpty) {
        final lastPoint = points.last;
        ref.read(startPointProvider.notifier).update((state) => lastPoint);
      } else {
        ref.read(startPointProvider.notifier).update((state) => details);
      }
      ref.read(endPointProvider.notifier).update((state) => details);
    } else {
      final selectedPointIndex = ref.read(selectedPointIndexProvider);
      if (selectedPointIndex != null) {
        final updatedPoints = List.of(points);
        updatedPoints[selectedPointIndex] = details;
        ref.read(pointsProvider.notifier).update((state) => updatedPoints);
        return;
      }
    }
  }

  void onPanUpdate(Offset details, WidgetRef ref) {
    final points = ref.read(pointsProvider);

    if (!ref.read(modeProvider)) {
      ref.read(endPointProvider.notifier).update((state) => details);
    } else {
      final selectedPointIndex = ref.read(selectedPointIndexProvider);
      if (selectedPointIndex != null) {
        final updatedPoints = List.of(points);
        updatedPoints[selectedPointIndex] = details;
        ref.read(pointsProvider.notifier).update((state) => updatedPoints);
        return;
      }
    }
  }

  void onUndo(WidgetRef ref) {
    final points = ref.read(pointsProvider);
    if (points.length < 4) {
      ref.read(modeProvider.notifier).update((state) => false);
    }
    final undoStack = ref.read(undoStackProvider);
    final redoStack = ref.read(redoStackProvider);

    if (undoStack.isNotEmpty) {
      final previousPoints = undoStack.removeLast();
      final currentPoints = ref.read(pointsProvider);
      ref
          .read(redoStackProvider.notifier)
          .update((state) => [...redoStack, currentPoints]);
      ref.read(pointsProvider.notifier).update((state) => previousPoints);
    }
  }

  void onRedo(WidgetRef ref) {
    final redoStack = ref.read(redoStackProvider);

    if (redoStack.isNotEmpty) {
      final nextPoints = redoStack.removeLast();
      final currentPoints = ref.read(pointsProvider);
      ref
          .read(undoStackProvider.notifier)
          .update((state) => [...redoStack, currentPoints]);
      ref.read(pointsProvider.notifier).update((state) => nextPoints);
    }
  }

  void updatePoints(List<Offset> updatedPoints, WidgetRef ref) =>
      ref.read(pointsProvider.notifier).state = updatedPoints;
}
