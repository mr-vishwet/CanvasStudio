import 'package:canvas_studio/src/rendering/export_renderer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/painting.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ExportRenderer', () {
    late CanvasDocument doc;

    setUp(() {
      doc = CanvasDocument.empty(canvasSize: const Size(400, 400));
    });

    test('renderToImage returns non-null image', () async {
      final image = await ExportRenderer.renderToImage(doc, pixelRatio: 1.0);
      expect(image.width, 400);
      expect(image.height, 400);
    });

    test('renderToBytes PNG returns non-empty bytes', () async {
      final result = await ExportRenderer.renderToBytes(
        doc,
        ExportFormat.png,
        pixelRatio: 1.0,
      );
      expect(result.bytes.isNotEmpty, true);
      expect(result.format, ExportFormat.png);
    });

    test('renderToBytes respects pixelRatio', () async {
      final result = await ExportRenderer.renderToImage(doc, pixelRatio: 2.0);
      expect(result.width, 800);
      expect(result.height, 800);
    });

    test('renderToBytes with layers returns valid PNG', () async {
      final docWithLayer = doc.copyWith(
        layers: [
          TextLayer(
            id: 'test_text',
            name: 'Test',
            position: const Offset(50, 50),
            size: const Size(300, 60),
            text: 'Export Test',
            fontFamily: 'Roboto',
            fontSize: 24,
          ),
          ShapeLayer(
            id: 'test_shape',
            name: 'BG',
            position: const Offset(0, 0),
            size: const Size(400, 400),
            shapeType: ShapeType.rectangle,
            fillColor: const Color(0xFF2196F3),
          ),
        ],
      );
      final result = await ExportRenderer.renderToBytes(
        docWithLayer,
        ExportFormat.png,
        pixelRatio: 1.0,
      );
      expect(result.bytes.length, greaterThan(1000));
    });

    test('ExportResult suggestedFileName has correct extension', () async {
      final result = await ExportRenderer.renderToBytes(
        doc,
        ExportFormat.png,
        pixelRatio: 1.0,
      );
      expect(result.suggestedFileName, endsWith('.png'));
    });
  });

  group('ExportConfig.resolve', () {
    test('image only → staticImage', () {
      final doc = CanvasDocument.empty(canvasSize: const Size(1080, 1080));
      final config = ExportConfig.resolve(
        document: doc,
        format: ExportFormat.png,
      );
      expect(config.outputType, ExportOutputType.staticImage);
      expect(config.frameMode, FrameMode.singleFrame);
    });

    test('image with audio → slideshowVideo', () {
      final doc = CanvasDocument.empty(
        canvasSize: const Size(1080, 1080),
      ).copyWith(
        audio: AudioConfig(
          trackId: 't1',
          trackUrl: 'http://example.com/audio.mp3',
          previewUrl: 'http://example.com/preview.mp3',
          trackName: 'Test Track',
          duration: const Duration(seconds: 15),
        ),
      );
      final config = ExportConfig.resolve(
        document: doc,
        format: ExportFormat.mp4,
      );
      expect(config.outputType, ExportOutputType.slideshowVideo);
    });
  });
}
