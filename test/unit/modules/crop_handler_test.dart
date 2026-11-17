import 'package:flutter/painting.dart';
import 'package:test/test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('CropHandler', () {
    test('clampToImage clamps crop to image bounds', () {
      final crop = Rect.fromLTWH(-10, -10, 200, 200);
      final imageSize = const Size(100, 100);
      final clamped = CropHandler.clampToImage(crop, imageSize);

      expect(clamped.left, 0.0);
      expect(clamped.top, 0.0);
      expect(clamped.right, 100.0);
      expect(clamped.bottom, 100.0);
    });

    test('clampToImage keeps valid crop unchanged', () {
      final crop = Rect.fromLTWH(10, 10, 50, 50);
      final imageSize = const Size(100, 100);
      final clamped = CropHandler.clampToImage(crop, imageSize);
      expect(clamped, crop);
    });

    test('normalize converts pixel rect to 0-1 range', () {
      final crop = Rect.fromLTWH(10, 20, 30, 40);
      final imageSize = const Size(100, 200);
      final normalized = CropHandler.normalize(crop, imageSize);

      expect(normalized.left, 0.1);
      expect(normalized.top, 0.1);
      expect(normalized.right, 0.4);
      expect(normalized.bottom, 0.3);
    });

    test('denormalize converts 0-1 rect to pixel coordinates', () {
      final norm = Rect.fromLTWH(0.1, 0.1, 0.4, 0.3);
      final imageSize = const Size(100, 200);
      final denormalized = CropHandler.denormalize(norm, imageSize);

      expect(denormalized.left, 10.0);
      expect(denormalized.top, 20.0);
      expect(denormalized.right, 40.0);
      expect(denormalized.bottom, 60.0);
    });

    test('normalize then denormalize returns original', () {
      final crop = Rect.fromLTWH(25, 50, 75, 150);
      const imageSize = Size(100, 200);
      final normalized = CropHandler.normalize(crop, imageSize);
      final denormalized = CropHandler.denormalize(normalized, imageSize);

      expect(denormalized.left, crop.left);
      expect(denormalized.top, crop.top);
      expect(denormalized.right, crop.right);
      expect(denormalized.bottom, crop.bottom);
    });
  });
}
