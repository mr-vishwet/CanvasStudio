import 'package:test/test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('AnimationPreview', () {
    test('hasAnimations returns false for empty document', () {
      final doc = CanvasDocument.empty(
        canvasSize: const Size(1080, 1080),
      );
      expect(AnimationPreview.hasAnimations(doc), isFalse);
    });

    test('hasAnimations returns true when layer has entrance animation', () {
      final layer = TextLayer(
        id: 'l1',
        name: 'Animated Text',
        position: const Offset(0, 0),
        size: const Size(100, 50),
        text: 'Hello',
        entranceAnimation: const AnimationConfig(
          type: AnimationType.fade,
          startTimeSeconds: 0,
          durationSeconds: 1,
        ),
      );
      final doc = CanvasDocument.empty(
        canvasSize: const Size(1080, 1080),
        layers: [layer],
      );
      expect(AnimationPreview.hasAnimations(doc), isTrue);
    });

    test('hasAnimations returns true when layer has exit animation', () {
      final layer = TextLayer(
        id: 'l1',
        name: 'Animated Text',
        position: const Offset(0, 0),
        size: const Size(100, 50),
        text: 'Hello',
        exitAnimation: const AnimationConfig(
          type: AnimationType.slideLeft,
          startTimeSeconds: 2,
          durationSeconds: 1,
        ),
      );
      final doc = CanvasDocument.empty(
        canvasSize: const Size(1080, 1080),
        layers: [layer],
      );
      expect(AnimationPreview.hasAnimations(doc), isTrue);
    });

    test('getLayerAnimations returns both entrance and exit animations', () {
      final layer = TextLayer(
        id: 'l1',
        name: 'Animated Text',
        position: const Offset(0, 0),
        size: const Size(100, 50),
        text: 'Hello',
        entranceAnimation: const AnimationConfig(
          type: AnimationType.fade,
          startTimeSeconds: 0,
          durationSeconds: 1,
        ),
        exitAnimation: const AnimationConfig(
          type: AnimationType.slideLeft,
          startTimeSeconds: 2,
          durationSeconds: 1,
        ),
      );
      final animations = AnimationPreview.getLayerAnimations(layer);
      expect(animations, hasLength(2));
      expect(animations[0].type, AnimationType.fade);
      expect(animations[1].type, AnimationType.slideLeft);
    });

    test('getLayerAnimations returns empty list when no animations', () {
      final layer = TextLayer(
        id: 'l1',
        name: 'Static Text',
        position: const Offset(0, 0),
        size: const Size(100, 50),
        text: 'Hello',
      );
      final animations = AnimationPreview.getLayerAnimations(layer);
      expect(animations, isEmpty);
    });

    test('totalDuration returns zero for no animations', () {
      final doc = CanvasDocument.empty(
        canvasSize: const Size(1080, 1080),
      );
      expect(AnimationPreview.totalDuration(doc), Duration.zero);
    });

    test('totalDuration calculates max end time across layers', () {
      final layer1 = TextLayer(
        id: 'l1',
        name: 'Layer 1',
        position: const Offset(0, 0),
        size: const Size(100, 50),
        text: 'Text 1',
        entranceAnimation: const AnimationConfig(
          type: AnimationType.fade,
          startTimeSeconds: 0,
          durationSeconds: 1,
        ),
      );
      final layer2 = TextLayer(
        id: 'l2',
        name: 'Layer 2',
        position: const Offset(0, 0),
        size: const Size(100, 50),
        text: 'Text 2',
        exitAnimation: const AnimationConfig(
          type: AnimationType.slideLeft,
          startTimeSeconds: 5,
          durationSeconds: 2,
        ),
      );
      final doc = CanvasDocument.empty(
        canvasSize: const Size(1080, 1080),
        layers: [layer1, layer2],
      );
      // Layer 2 exit ends at 5+2=7 seconds, which is the max
      expect(AnimationPreview.totalDuration(doc), const Duration(seconds: 7));
    });

    test('totalDuration uses entrance animation end time', () {
      final layer = TextLayer(
        id: 'l1',
        name: 'Layer 1',
        position: const Offset(0, 0),
        size: const Size(100, 50),
        text: 'Text',
        entranceAnimation: const AnimationConfig(
          type: AnimationType.zoom,
          startTimeSeconds: 3,
          durationSeconds: 2,
        ),
      );
      final doc = CanvasDocument.empty(
        canvasSize: const Size(1080, 1080),
        layers: [layer],
      );
      // 3 + 2 = 5 seconds
      expect(AnimationPreview.totalDuration(doc), const Duration(seconds: 5));
    });

    test('AnimationType has all values', () {
      expect(AnimationType.values, hasLength(8));
      expect(AnimationType.fade.name, 'fade');
      expect(AnimationType.slideLeft.name, 'slideLeft');
      expect(AnimationType.slideRight.name, 'slideRight');
      expect(AnimationType.slideUp.name, 'slideUp');
      expect(AnimationType.slideDown.name, 'slideDown');
      expect(AnimationType.zoom.name, 'zoom');
      expect(AnimationType.bounce.name, 'bounce');
      expect(AnimationType.rotate.name, 'rotate');
    });

    test('AnimationConfig copyWith works', () {
      const config = AnimationConfig(
        type: AnimationType.fade,
        startTimeSeconds: 0,
        durationSeconds: 1,
      );
      final updated = config.copyWith(
        type: AnimationType.zoom,
        durationSeconds: 2,
      );
      expect(updated.type, AnimationType.zoom);
      expect(updated.startTimeSeconds, 0);
      expect(updated.durationSeconds, 2);
    });

    test('AnimationConfig toJson and fromJson round-trip', () {
      const config = AnimationConfig(
        type: AnimationType.bounce,
        startTimeSeconds: 1.5,
        durationSeconds: 0.8,
      );
      final json = config.toJson();
      final restored = AnimationConfig.fromJson(json);
      expect(restored.type, AnimationType.bounce);
      expect(restored.startTimeSeconds, 1.5);
      expect(restored.durationSeconds, 0.8);
    });
  });
}
