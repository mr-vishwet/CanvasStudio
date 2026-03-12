import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/painting.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('HistoryManager', () {
    late HistoryManager history;
    late CanvasDocument docA;
    late CanvasDocument docB;
    late CanvasDocument docC;

    setUp(() {
      history = HistoryManager();
      docA = CanvasDocument.empty(canvasSize: const Size(1080, 1080));
      docB = docA.copyWith();
      docC = docA.copyWith();
    });

    test('canUndo is false initially', () {
      expect(history.canUndo, false);
    });

    test('canRedo is false initially', () {
      expect(history.canRedo, false);
    });

    test('push enables canUndo', () {
      history.push(docA);
      expect(history.canUndo, true);
    });

    test('undo returns pushed document', () {
      history.push(docA);
      final restored = history.undo(docB);
      expect(restored?.id, docA.id);
    });

    test('undo enables canRedo', () {
      history.push(docA);
      history.undo(docB);
      expect(history.canRedo, true);
    });

    test('redo returns undone document', () {
      history.push(docA);
      history.undo(docB);
      final redone = history.redo(docA);
      expect(redone?.id, docB.id);
    });

    test('new push after undo clears redo stack', () {
      history.push(docA);
      history.undo(docB);
      history.push(docB); // new action
      expect(history.canRedo, false);
    });

    test('undo returns null when stack empty', () {
      expect(history.undo(docA), null);
    });

    test('clear resets both stacks', () {
      history.push(docA);
      history.push(docB);
      history.clear();
      expect(history.canUndo, false);
      expect(history.canRedo, false);
    });

    test('max 50 undo steps enforced', () {
      for (int i = 0; i < 60; i++) {
        history.push(CanvasDocument.empty(canvasSize: const Size(1080, 1080)));
      }
      expect(history.undoCount, 50);
    });
  });
}
