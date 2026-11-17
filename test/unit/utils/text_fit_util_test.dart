import 'package:flutter/painting.dart';
import 'package:test/test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('TextFitUtil', () {
    test('fitFontSize returns maxFontSize for short text', () {
      final size = TextFitUtil.fitFontSize(
        'Hi',
        maxWidth: 500.0,
        maxHeight: 100.0,
        maxFontSize: 100.0,
        minFontSize: 8.0,
      );
      expect(size, 100.0);
    });

    test('fitFontSize returns minFontSize for very long text', () {
      final size = TextFitUtil.fitFontSize(
        'This is a very long text that will never fit in a tiny width',
        maxWidth: 10.0,
        maxHeight: 100.0,
        maxFontSize: 100.0,
        minFontSize: 8.0,
      );
      expect(size, 8.0);
    });

    test('fitFontSize respects maxHeight', () {
      final size = TextFitUtil.fitFontSize(
        'Hi',
        maxWidth: 500.0,
        maxHeight: 5.0,
        maxFontSize: 100.0,
        minFontSize: 8.0,
      );
      expect(size, 8.0);
    });

    test('fitFontSize returns value between min and max', () {
      final size = TextFitUtil.fitFontSize(
        'Hello',
        maxWidth: 100.0,
        maxHeight: 50.0,
        maxFontSize: 50.0,
        minFontSize: 10.0,
      );
      expect(size, greaterThanOrEqualTo(10.0));
      expect(size, lessThanOrEqualTo(50.0));
    });
  });
}
