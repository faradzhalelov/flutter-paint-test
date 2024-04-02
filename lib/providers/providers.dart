import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/canvas_state.dart';

final pointsProvider = StateProvider<List<Offset>>((ref) => []);
final modeProvider = StateProvider<bool>((ref) => false);
final undoStackProvider = StateProvider<List<List<Offset>>>((ref) => []);
final redoStackProvider = StateProvider<List<List<Offset>>>((ref) => []);

final selectedPointIndexProvider = StateProvider<int?>((ref) => null);

final startPointProvider = StateProvider<Offset>((ref) => Offset.zero);
final endPointProvider = StateProvider<Offset>((ref) => Offset.zero);
final filledProvider = StateProvider<bool>((ref) => false);

final canvasStateProvider =
    StateProvider<CanvasState>((ref) => CanvasState.draw);
final panOffsetProvider = StateProvider<Offset>((ref) => Offset.zero);
