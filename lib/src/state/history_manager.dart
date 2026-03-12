import 'dart:collection';
import '../models/canvas_document.dart';

class HistoryManager {
  static const int _maxHistory = 50;

  final ListQueue<CanvasDocument> _undoStack = ListQueue();
  final ListQueue<CanvasDocument> _redoStack = ListQueue();

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;
  int get undoCount => _undoStack.length;
  int get redoCount => _redoStack.length;

  /// Call BEFORE applying any mutation — saves current state
  void push(CanvasDocument snapshot) {
    _undoStack.addLast(snapshot);
    // Any new action clears the redo stack
    _redoStack.clear();
    // Cap stack size
    if (_undoStack.length > _maxHistory) {
      _undoStack.removeFirst();
    }
  }

  /// Returns the previous document state (to restore)
  /// Caller must pass the CURRENT document so we can push it to redo
  CanvasDocument? undo(CanvasDocument current) {
    if (!canUndo) return null;
    _redoStack.addLast(current);
    return _undoStack.removeLast();
  }

  /// Returns the next document state (to restore)
  /// Caller must pass the CURRENT document so we can push it to undo
  CanvasDocument? redo(CanvasDocument current) {
    if (!canRedo) return null;
    _undoStack.addLast(current);
    return _redoStack.removeLast();
  }

  /// Full reset — called when loading a new template
  void clear() {
    _undoStack.clear();
    _redoStack.clear();
  }
}
