import 'package:test/test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('AudioLibraryController (state)', () {
    test('initializes with empty tracks', () {
      final controller = AudioLibraryController(null);
      expect(controller.tracks, isEmpty);
      expect(controller.isLoading, false);
      expect(controller.selected, null);
    });

    test('setTracks updates tracks and notifies', () {
      final controller = AudioLibraryController(null);
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);

      controller.setTracks([
        const AudioTrack(
          id: 'at_1',
          title: 'Track 1',
          artist: 'Artist 1',
          url: 'https://cdn.example.com/t1.mp3',
          durationMs: 180000,
        ),
      ]);

      expect(controller.tracks, hasLength(1));
      expect(controller.tracks.first.title, 'Track 1');
      expect(notifyCount, 1);
    });

    test('setLoading updates isLoading and notifies', () {
      final controller = AudioLibraryController(null);
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);

      controller.setLoading(true);
      expect(controller.isLoading, true);
      expect(notifyCount, 1);

      controller.setLoading(false);
      expect(controller.isLoading, false);
      expect(notifyCount, 2);
    });

    test('selectTrack updates selected and notifies', () {
      final controller = AudioLibraryController(null);
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);

      const track = AudioTrack(
        id: 'at_1',
        title: 'Track 1',
        artist: 'Artist 1',
        url: 'https://cdn.example.com/t1.mp3',
        durationMs: 180000,
      );
      controller.selectTrack(track);
      expect(controller.selected, track);
      expect(notifyCount, 1);

      controller.selectTrack(null);
      expect(controller.selected, null);
      expect(notifyCount, 2);
    });

    test('selectedAsConfig returns null when no track selected', () {
      final controller = AudioLibraryController(null);
      expect(controller.selectedAsConfig(), null);
    });

    test('selectedAsConfig returns AudioConfig when track selected', () {
      final controller = AudioLibraryController(null);
      const track = AudioTrack(
        id: 'at_1',
        title: 'Track 1',
        artist: 'Artist 1',
        url: 'https://cdn.example.com/t1.mp3',
        previewUrl: 'https://cdn.example.com/t1_preview.mp3',
        durationMs: 180000,
        festival: 'diwali',
      );
      controller.selectTrack(track);

      final config = controller.selectedAsConfig();
      expect(config, isNotNull);
      expect(config!.trackId, 'at_1');
      expect(config.trackUrl, 'https://cdn.example.com/t1.mp3');
      expect(config.previewUrl, 'https://cdn.example.com/t1_preview.mp3');
      expect(config.trackName, 'Track 1');
      expect(config.duration, const Duration(milliseconds: 180000));
      expect(config.festival, 'diwali');
    });

    test('disposing does not throw', () {
      final controller = AudioLibraryController(null);
      controller.dispose();
      expect(true, isTrue);
    });
  });
}
