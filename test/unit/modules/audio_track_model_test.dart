import 'package:test/test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('AudioTrack', () {
    const track = AudioTrack(
      id: 'at_001',
      title: 'Diwali Beat',
      artist: 'DJ India',
      url: 'https://cdn.example.com/diwali_beat.mp3',
      previewUrl: 'https://cdn.example.com/diwali_beat_preview.mp3',
      durationMs: 180000,
      category: 'festival',
      festival: 'diwali',
      isPremium: false,
    );

    test('toJson produces correct map', () {
      final json = track.toJson();
      expect(json['id'], 'at_001');
      expect(json['title'], 'Diwali Beat');
      expect(json['artist'], 'DJ India');
      expect(json['url'], 'https://cdn.example.com/diwali_beat.mp3');
      expect(json['preview_url'], 'https://cdn.example.com/diwali_beat_preview.mp3');
      expect(json['duration_ms'], 180000);
      expect(json['category'], 'festival');
      expect(json['festival'], 'diwali');
      expect(json['is_premium'], false);
    });

    test('fromJson reconstructs track correctly', () {
      final json = {
        'id': 'at_002',
        'title': 'Bollywood Mix',
        'artist': 'A.R. Rahman',
        'url': 'https://cdn.example.com/bollywood.mp3',
        'preview_url': null,
        'duration_ms': 240000,
        'category': 'bollywood',
        'festival': null,
        'is_premium': true,
      };
      final restored = AudioTrack.fromJson(json);
      expect(restored.id, 'at_002');
      expect(restored.title, 'Bollywood Mix');
      expect(restored.artist, 'A.R. Rahman');
      expect(restored.url, 'https://cdn.example.com/bollywood.mp3');
      expect(restored.previewUrl, null);
      expect(restored.durationMs, 240000);
      expect(restored.category, 'bollywood');
      expect(restored.festival, null);
      expect(restored.isPremium, true);
    });

    test('round-trip preserves data', () {
      final json = track.toJson();
      final restored = AudioTrack.fromJson(json);
      expect(restored.id, track.id);
      expect(restored.title, track.title);
      expect(restored.durationMs, track.durationMs);
      expect(restored.isPremium, track.isPremium);
    });

    test('default values work', () {
      const minimal = AudioTrack(
        id: 'at_min',
        title: 'Minimal Track',
        artist: 'Unknown',
        url: 'https://cdn.example.com/min.mp3',
        durationMs: 60000,
      );
      expect(minimal.previewUrl, null);
      expect(minimal.category, null);
      expect(minimal.festival, null);
      expect(minimal.isPremium, false);
    });
  });
}
