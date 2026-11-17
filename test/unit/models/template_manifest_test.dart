import 'package:flutter/painting.dart';
import 'package:test/test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('TemplateManifest', () {
    final manifest = TemplateManifest(
      schemaVersion: '1.0',
      id: 'tpl_001',
      name: 'Diwali Poster',
      category: 'festival',
      tags: ['diwali', 'sale', 'poster'],
      ratio: TemplateAspectRatio.square_1x1,
      canvasSize: const Size(1080, 1080),
      type: 'image',
      videoDurationMs: null,
      thumbnailUrl: 'https://cdn.example.com/tpl_001_thumb.jpg',
      previewGifUrl: 'https://cdn.example.com/tpl_001_preview.gif',
      source: TemplateSource.self_hosted,
      defaultAudioId: 'audio_festival_01',
      layers: [
        {'id': 'l1', 'type': 'text', 'name': 'Title'},
      ],
    );

    test('toJson produces correct map', () {
      final json = manifest.toJson();
      expect(json['schema_version'], '1.0');
      expect(json['id'], 'tpl_001');
      expect(json['name'], 'Diwali Poster');
      expect(json['category'], 'festival');
      expect(json['tags'], ['diwali', 'sale', 'poster']);
      expect(json['ratio'], 'square_1x1');
      expect(json['canvas_size'], {'width': 1080.0, 'height': 1080.0});
      expect(json['type'], 'image');
      expect(json['video_duration_ms'], null);
      expect(json['thumbnail_url'], 'https://cdn.example.com/tpl_001_thumb.jpg');
      expect(json['preview_gif_url'], 'https://cdn.example.com/tpl_001_preview.gif');
      expect(json['source'], 'self_hosted');
      expect(json['default_audio_id'], 'audio_festival_01');
      expect(json['layers'], [{'id': 'l1', 'type': 'text', 'name': 'Title'}]);
    });

    test('fromJson reconstructs manifest correctly', () {
      final json = {
        'schema_version': '1.0',
        'id': 'tpl_002',
        'name': 'Business Card',
        'category': 'business',
        'tags': ['business', 'card'],
        'ratio': 'portrait_9x16',
        'canvas_size': {'width': 1080, 'height': 1920},
        'type': 'image',
        'video_duration_ms': null,
        'thumbnail_url': null,
        'preview_gif_url': null,
        'source': 'vendor_cdn',
        'default_audio_id': null,
        'layers': [],
      };
      final restored = TemplateManifest.fromJson(json);
      expect(restored.id, 'tpl_002');
      expect(restored.name, 'Business Card');
      expect(restored.category, 'business');
      expect(restored.tags, ['business', 'card']);
      expect(restored.ratio, TemplateAspectRatio.portrait_9x16);
      expect(restored.canvasSize, const Size(1080.0, 1920.0));
      expect(restored.type, 'image');
      expect(restored.source, TemplateSource.vendor_cdn);
      expect(restored.defaultAudioId, null);
      expect(restored.layers, []);
    });

    test('fromJson uses defaults for missing optional fields', () {
      final json = {
        'id': 'tpl_minimal',
        'name': 'Minimal',
        'ratio': 'square_1x1',
        'canvas_size': {'width': 100, 'height': 100},
      };
      final restored = TemplateManifest.fromJson(json);
      expect(restored.schemaVersion, '1.0');
      expect(restored.category, null);
      expect(restored.tags, []);
      expect(restored.type, 'image');
      expect(restored.source, TemplateSource.self_hosted);
      expect(restored.defaultAudioId, null);
      expect(restored.layers, []);
    });

    test('round-trip toJson then fromJson preserves data', () {
      final json = manifest.toJson();
      final restored = TemplateManifest.fromJson(json);
      expect(restored.id, manifest.id);
      expect(restored.name, manifest.name);
      expect(restored.category, manifest.category);
      expect(restored.ratio, manifest.ratio);
      expect(restored.canvasSize, manifest.canvasSize);
      expect(restored.source, manifest.source);
    });

    test('TemplateAspectRatio has all four values', () {
      expect(TemplateAspectRatio.values, hasLength(4));
      expect(TemplateAspectRatio.square_1x1.name, 'square_1x1');
      expect(TemplateAspectRatio.portrait_9x16.name, 'portrait_9x16');
      expect(TemplateAspectRatio.landscape_16x9.name, 'landscape_16x9');
      expect(TemplateAspectRatio.a4_print.name, 'a4_print');
    });

    test('TemplateSource has all three values', () {
      expect(TemplateSource.values, hasLength(3));
      expect(TemplateSource.self_hosted.name, 'self_hosted');
      expect(TemplateSource.vendor_cdn.name, 'vendor_cdn');
      expect(TemplateSource.user_custom.name, 'user_custom');
    });
  });
}
