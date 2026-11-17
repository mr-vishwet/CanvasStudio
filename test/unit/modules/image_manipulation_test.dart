import 'package:test/test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('ImageManipulation', () {
    test('applyEffect updates layer effects', () {
      final layer = ImageLayer(
        id: 'l1',
        name: 'Image',
        position: const Offset(0, 0),
        size: const Size(200, 200),
        imageUrl: 'https://cdn.example.com/image.jpg',
        effects: const EffectConfig(),
      );

      final updated = ImageManipulation.applyEffect(layer, const EffectConfig(
        brightness: 0.5,
        contrast: 0.3,
      ));

      expect(updated.effects.brightness, 0.5);
      expect(updated.effects.contrast, 0.3);
      expect(updated.effects.saturation, 0.0);
      expect(updated.effects.blurRadius, 0.0);
      expect(updated.effects.vignette, 0.0);
      // Original should be unchanged (immutable)
      expect(layer.effects.isIdentity, isTrue);
    });

    test('resetEffects returns identity config', () {
      final layer = ImageLayer(
        id: 'l1',
        name: 'Image',
        position: const Offset(0, 0),
        size: const Size(200, 200),
        imageUrl: 'https://cdn.example.com/image.jpg',
        effects: const EffectConfig(
          brightness: 0.5,
          blurRadius: 5.0,
        ),
      );

      final reset = ImageManipulation.resetEffects(layer);
      expect(reset.effects.isIdentity, isTrue);
    });

    test('hasEffects returns true for non-identity config', () {
      final layer = ImageLayer(
        id: 'l1',
        name: 'Image',
        position: const Offset(0, 0),
        size: const Size(200, 200),
        imageUrl: 'https://cdn.example.com/image.jpg',
        effects: const EffectConfig(brightness: 0.3),
      );
      expect(ImageManipulation.hasEffects(layer), isTrue);
    });

    test('hasEffects returns false for identity config', () {
      final layer = ImageLayer(
        id: 'l1',
        name: 'Image',
        position: const Offset(0, 0),
        size: const Size(200, 200),
        imageUrl: 'https://cdn.example.com/image.jpg',
        effects: const EffectConfig(),
      );
      expect(ImageManipulation.hasEffects(layer), isFalse);
    });
  });
}
