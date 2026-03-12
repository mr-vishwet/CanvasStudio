import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';
import '../models/layer/layer.dart';
import '../state/canvas_controller.dart';

class _GestureSession {
  final String layerId;
  final Offset startPosition;    // layer position at gesture start
  final double startRotation;    // layer rotation at gesture start
  final Size startSize;          // layer size at gesture start
  final Offset startFocalCanvas; // focal point in canvas coords at start
  final double startScale;       // scale at gesture start (always 1.0)

  const _GestureSession({
    required this.layerId,
    required this.startPosition,
    required this.startRotation,
    required this.startSize,
    required this.startFocalCanvas,
    required this.startScale,
  });
}

class GestureHandler {
  final CanvasController controller;

  /// Scale factor: canvas logical pixels → screen pixels
  /// Set by CanvasView based on InteractiveViewer zoom level
  double canvasScale = 1.0;

  _GestureSession? _activeSession;
  double _lastScale = 1.0;
  double _lastRotation = 0.0;

  GestureHandler({required this.controller});


  void onScaleStart(ScaleStartDetails details, Offset canvasOffset) {
    final focalCanvas = _screenToCanvas(details.localFocalPoint, canvasOffset);
    final layer = controller.hitTest(focalCanvas);

    if (layer == null) {
      controller.clearSelection();
      _activeSession = null;
      return;
    }

    if (layer.isLocked) return;

    controller.selectLayer(layer.id);

    _activeSession = _GestureSession(
      layerId: layer.id,
      startPosition: layer.position,
      startRotation: layer.rotation,
      startSize: layer.size,
      startFocalCanvas: focalCanvas,
      startScale: 1.0,
    );
    _lastScale = 1.0;
    _lastRotation = 0.0;
  }

  void onScaleUpdate(ScaleUpdateDetails details, Offset canvasOffset) {
    final session = _activeSession;
    if (session == null) return;

    final focalCanvas = _screenToCanvas(details.localFocalPoint, canvasOffset);

    if (details.pointerCount == 1) {
      final delta = focalCanvas - session.startFocalCanvas;
      controller.setLayerPosition(
        session.layerId,
        session.startPosition + delta,
      );
    } else {
      final scaleDelta = details.scale / _lastScale;
      final rotationDelta = details.rotation - _lastRotation; // radians

      final currentLayer = controller.layers.firstWhere(
            (l) => l.id == session.layerId,
        orElse: () => throw StateError('Layer not found'),
      );

      final newWidth = (currentLayer.size.width * scaleDelta)
          .clamp(20.0, double.infinity);
      final newHeight = (currentLayer.size.height * scaleDelta)
          .clamp(20.0, double.infinity);

      final newRotation = currentLayer.rotation +
          (rotationDelta * 180 / math.pi);

      controller.resizeLayer(session.layerId, Size(newWidth, newHeight));
      controller.rotateLayer(session.layerId, newRotation);

      _lastScale = details.scale;
      _lastRotation = details.rotation;
    }
  }


  void onScaleEnd(ScaleEndDetails details) {
    _activeSession = null;
    _lastScale = 1.0;
    _lastRotation = 0.0;
  }


  void onTap(Offset localPosition, Offset canvasOffset) {
    final canvasPoint = _screenToCanvas(localPosition, canvasOffset);
    final layer = controller.hitTest(canvasPoint);
    controller.selectLayer(layer?.id);
  }


  void onDoubleTap(Offset localPosition, Offset canvasOffset) {
    final canvasPoint = _screenToCanvas(localPosition, canvasOffset);
    final layer = controller.hitTest(canvasPoint);
    if (layer == null) return;
    controller.selectLayer(layer.id);
    controller.enterTextEditModeIfText(layer.id);
  }


  Offset _screenToCanvas(Offset screenPoint, Offset canvasOriginOnScreen) {
    return (screenPoint - canvasOriginOnScreen) / canvasScale;
  }
}
