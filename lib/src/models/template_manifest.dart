import 'package:flutter/painting.dart';

enum TemplateAspectRatio { square_1x1, portrait_9x16, landscape_16x9, a4_print }

enum TemplateSource { self_hosted, vendor_cdn, user_custom }

class TemplateManifest {
  final String schemaVersion;
  final String id;
  final String name;
  final String? category;
  final List<String> tags;
  final TemplateAspectRatio ratio;
  final Size canvasSize;
  final String type;
  final int? videoDurationMs;
  final String? thumbnailUrl;
  final String? previewGifUrl;
  final TemplateSource source;
  final String? defaultAudioId;
  final List<Map<String, dynamic>> layers;

  const TemplateManifest({
    required this.schemaVersion,
    required this.id,
    required this.name,
    this.category,
    this.tags = const [],
    required this.ratio,
    required this.canvasSize,
    this.type = 'image',
    this.videoDurationMs,
    this.thumbnailUrl,
    this.previewGifUrl,
    this.source = TemplateSource.self_hosted,
    this.defaultAudioId,
    this.layers = const [],
  });

  Map<String, dynamic> toJson() => {
    'schema_version': schemaVersion,
    'id': id,
    'name': name,
    'category': category,
    'tags': tags,
    'ratio': ratio.name,
    'canvas_size': {'width': canvasSize.width, 'height': canvasSize.height},
    'type': type,
    'video_duration_ms': videoDurationMs,
    'thumbnail_url': thumbnailUrl,
    'preview_gif_url': previewGifUrl,
    'source': source.name,
    'default_audio_id': defaultAudioId,
    'layers': layers,
  };

  factory TemplateManifest.fromJson(Map<String, dynamic> json) =>
      TemplateManifest(
        schemaVersion: json['schema_version'] as String? ?? '1.0',
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String?,
        tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
        ratio: TemplateAspectRatio.values.byName(
          json['ratio'] as String? ?? 'square_1x1',
        ),
        canvasSize: Size(
          (json['canvas_size']['width'] as num).toDouble(),
          (json['canvas_size']['height'] as num).toDouble(),
        ),
        type: json['type'] as String? ?? 'image',
        videoDurationMs: json['video_duration_ms'] as int?,
        thumbnailUrl: json['thumbnail_url'] as String?,
        previewGifUrl: json['preview_gif_url'] as String?,
        source: TemplateSource.values.byName(
          json['source'] as String? ?? 'self_hosted',
        ),
        defaultAudioId: json['default_audio_id'] as String?,
        layers: (json['layers'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [],
      );
}
