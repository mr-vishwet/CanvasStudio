import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import '../models/canvas_document.dart';
import '../models/export/export_config.dart';
import '../state/selection_state.dart';
import 'canvas_painter.dart';
import 'package:image/image.dart' as img;


class ExportRenderer {
  static Future<ui.Image> renderToImage(
      CanvasDocument document, {
        double pixelRatio = 3.0,
      }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, document.canvasSize.width, document.canvasSize.height),
    );

    final painter = CanvasPainter(
      document: document,
      selection: const SelectionState(),
      isExporting: true,
    );

    painter.paint(canvas, document.canvasSize);

    final picture = recorder.endRecording();

    final image = await picture.toImage(
      (document.canvasSize.width * pixelRatio).round(),
      (document.canvasSize.height * pixelRatio).round(),
    );

    return image;
  }

  // Replace renderToBytes method:
  static Future<ExportResult> renderToBytes(
      CanvasDocument document,
      ExportFormat format, {
        double pixelRatio = 3.0,
        int jpgQuality = 92,
      }) async {
    final uiImage = await renderToImage(document, pixelRatio: pixelRatio);

    final List<int> bytes;
    final int w = uiImage.width;
    final int h = uiImage.height;

    if (format == ExportFormat.png) {
      final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw StateError('PNG encode failed');
      bytes = byteData.buffer.asUint8List();
    } else {
      // JPG: rawRgba → img.Image → encodeJpg
      final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData == null) throw StateError('RGBA read failed');
      final raw = byteData.buffer.asUint8List();
      final imgLib = img.Image.fromBytes(width: w, height: h, bytes: raw.buffer);
      bytes = img.encodeJpg(imgLib, quality: jpgQuality);
    }

    return ExportResult(
      bytes: bytes,
      width: w,
      height: h,
      format: format,
    );
  }
}

class ExportResult {
  final List<int> bytes;
  final int width;
  final int height;
  final ExportFormat format;

  const ExportResult({
    required this.bytes,
    required this.width,
    required this.height,
    required this.format,
  });

  String get suggestedFileName =>
      'canvas_export_${DateTime.now().millisecondsSinceEpoch}'
          '.${format.name}';
}
