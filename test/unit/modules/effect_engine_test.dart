import 'package:flutter/painting.dart';
import 'package:test/test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('EffectEngine', () {
    test('colorFilter creates brightness matrix', () {
      final effect = const EffectConfig(brightness: 0.5);
      final filter = EffectEngine.colorFilter(effect);
      expect(filter, isA<ColorFilter>());
    });

    test('colorFilter creates contrast matrix', () {
      final effect = const EffectConfig(contrast: 0.3);
      final filter = EffectEngine.colorFilter(effect);
      expect(filter, isA<ColorFilter>());
    });

    test('blurFilter returns ImageFilter.none for zero radius', () {
      final filter = EffectEngine.blurFilter(0.0);
      expect(filter, ImageFilter.none);
    });

    test('blurFilter returns ImageFilter.blur for positive radius', () {
      final filter = EffectEngine.blurFilter(5.0);
      expect(filter, isA<ImageFilter>());
      expect(filter, isNot(ImageFilter.none));
    });

    test('needsShader returns true for non-zero saturation', () {
      final effect = const EffectConfig(saturation: 0.5);
      expect(EffectEngine.needsShader(effect), isTrue);
    });

    test('needsShader returns true for non-zero vignette', () {
      final effect = const EffectConfig(vignette: 0.3);
      expect(EffectEngine.needsShader(effect), isTrue);
    });

    test('needsShader returns false for identity config', () {
      final effect = const EffectConfig();
      expect(EffectEngine.needsShader(effect), isFalse);
    });

    test('needsShader returns false for brightness/contrast only', () {
      final effect = const EffectConfig(brightness: 0.5, contrast: 0.3);
      expect(EffectEngine.needsShader(effect), isFalse);
    });
  });
}
