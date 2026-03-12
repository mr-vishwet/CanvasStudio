import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import '../models/canvas_document.dart';
import '../state/selection_state.dart';
import 'layer_renderer.dart';

class CanvasPainter extends CustomPainter {
  final CanvasDocument document;
  final SelectionState selection;
  final bool isExporting;
  final bool showSnapLines;
  final List<Offset> snapLinePoints;

  const CanvasPainter({
    required this.document,
    required this.selection,
    this.isExporting = false,
    this.showSnapLines = false,
    this.snapLinePoints = const [],
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final layer in document.layers) {
      canvas.save();
      canvas.saveLayer(
        Rect.fromLTWH(
          layer.position.dx,
          layer.position.dy,
          layer.size.width,
          layer.size.height,
        ),
        Paint(),
      );
      LayerRenderer.render(layer, canvas, isExporting: isExporting);
      canvas.restore();
      canvas.restore();
    }

    if (!isExporting) {
      _paintSelectionHandles(canvas);
      if (showSnapLines) _paintSnapLines(canvas);
    }
  }

  void _paintSelectionHandles(Canvas canvas) {
    if (!selection.hasSelection) return;
    final layer = selection.resolveLayer(document.layers);
    if (layer == null) return;

    final rect = Rect.fromLTWH(
      layer.position.dx,
      layer.position.dy,
      layer.size.width,
      layer.size.height,
    );

    final borderPaint = Paint()
      ..color = const Color(0xFF2196F3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.save();
    final center = rect.center;
    canvas.translate(center.dx, center.dy);
    canvas.rotate(layer.rotation * (3.141592653589793 / 180));
    canvas.translate(-center.dx, -center.dy);

    canvas.drawRect(rect, borderPaint);

    _drawHandle(canvas, rect.topLeft);
    _drawHandle(canvas, rect.topCenter);
    _drawHandle(canvas, rect.topRight);
    _drawHandle(canvas, rect.centerLeft);
    _drawHandle(canvas, rect.centerRight);
    _drawHandle(canvas, rect.bottomLeft);
    _drawHandle(canvas, rect.bottomCenter);
    _drawHandle(canvas, rect.bottomRight);

    // Rotation handle above top center
    final rotHandle = Offset(rect.topCenter.dx, rect.topCenter.dy - 24);
    canvas.drawLine(rect.topCenter, rotHandle, borderPaint);
    _drawHandle(canvas, rotHandle, isRotation: true);

    canvas.restore();
  }

  void _drawHandle(Canvas canvas, Offset center, {bool isRotation = false}) {
    final fill = Paint()..color = const Color(0xFFFFFFFF);
    final border = Paint()
      ..color = const Color(0xFF2196F3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    const r = 5.0;
    if (isRotation) {
      canvas.drawCircle(center, r, fill);
      canvas.drawCircle(center, r, border);
    } else {
      canvas.drawRect(Rect.fromCircle(center: center, radius: r), fill);
      canvas.drawRect(Rect.fromCircle(center: center, radius: r), border);
    }
  }

  void _paintSnapLines(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFFFF5722)
      ..strokeWidth = 1.0;
    for (int i = 0; i < snapLinePoints.length - 1; i += 2) {
      canvas.drawLine(snapLinePoints[i], snapLinePoints[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) =>
      oldDelegate.document != document ||
          oldDelegate.selection != selection ||
          oldDelegate.showSnapLines != showSnapLines;
}
