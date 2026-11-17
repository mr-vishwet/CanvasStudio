import 'package:flutter/foundation.dart';
import 'package:test/test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('VideoTrimState', () {
    test('initializes with provided config', () {
      const config = VideoTrimConfig(
        startTrim: Duration(seconds: 5),
        endTrim: Duration(seconds: 30),
        rotation: 90,
      );
      final state = VideoTrimState(config: config);
      expect(state.config.startTrim, const Duration(seconds: 5));
      expect(state.config.endTrim, const Duration(seconds: 30));
      expect(state.config.rotation, 90);
    });

    test('setStart updates startTrim and notifies', () {
      const config = VideoTrimConfig(
        startTrim: Duration(seconds: 0),
        endTrim: Duration(seconds: 30),
      );
      final state = VideoTrimState(config: config);
      var notifyCount = 0;
      state.addListener(() => notifyCount++);

      state.setStart(const Duration(seconds: 10));
      expect(state.config.startTrim, const Duration(seconds: 10));
      expect(state.config.endTrim, const Duration(seconds: 30));
      expect(notifyCount, 1);
    });

    test('setEnd updates endTrim and notifies', () {
      const config = VideoTrimConfig(
        startTrim: Duration(seconds: 0),
        endTrim: Duration(seconds: 30),
      );
      final state = VideoTrimState(config: config);
      var notifyCount = 0;
      state.addListener(() => notifyCount++);

      state.setEnd(const Duration(seconds: 60));
      expect(state.config.endTrim, const Duration(seconds: 60));
      expect(notifyCount, 1);
    });

    test('setCrop updates minCrop and maxCrop', () {
      const config = VideoTrimConfig(
        startTrim: Duration.zero,
        endTrim: Duration(seconds: 30),
      );
      final state = VideoTrimState(config: config);

      state.setCrop(const Offset(0.1, 0.1), const Offset(0.9, 0.9));
      expect(state.config.minCrop, const Offset(0.1, 0.1));
      expect(state.config.maxCrop, const Offset(0.9, 0.9));
    });

    test('rotate90 increments rotation by 90 degrees', () {
      const config = VideoTrimConfig(
        startTrim: Duration.zero,
        endTrim: Duration(seconds: 30),
        rotation: 0,
      );
      final state = VideoTrimState(config: config);

      state.rotate90();
      expect(state.config.rotation, 90);

      state.rotate90();
      expect(state.config.rotation, 180);

      state.rotate90();
      expect(state.config.rotation, 270);

      state.rotate90();
      expect(state.config.rotation, 0);
    });

    test('trimmedDuration returns end - start', () {
      const config = VideoTrimConfig(
        startTrim: Duration(seconds: 5),
        endTrim: Duration(seconds: 25),
      );
      final state = VideoTrimState(config: config);
      expect(state.trimmedDuration, const Duration(seconds: 20));
    });

    test('disposing does not throw', () {
      const config = VideoTrimConfig(
        startTrim: Duration.zero,
        endTrim: Duration(seconds: 30),
      );
      final state = VideoTrimState(config: config);
      state.dispose();
      expect(true, isTrue);
    });
  });
}
