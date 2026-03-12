import 'package:flutter/painting.dart';
import 'layer/layers.dart';

import 'audio_config.dart';
import 'export/video_trim_config.dart';

enum CanvasMediaType { image, video }

class CanvasDocument {
  final String id;
  final String? templateId;
  final Size canvasSize;
  final CanvasMediaType type;
  final List<Layer> layers; // index 0 = bottommost (background)
  final AudioConfig? audio;
  final VideoTrimConfig? videoTrim;
  final DateTime updatedAt;

  const CanvasDocument({
    required this.id,
    required this.canvasSize,
    required this.type,
    required this.layers,
    required this.updatedAt,
    this.templateId,
    this.audio,
    this.videoTrim,
  });

  // Convenience factory — empty canvas
  factory CanvasDocument.empty({
    required Size canvasSize,
    CanvasMediaType type = CanvasMediaType.image,
  }) =>
      CanvasDocument(
        id: _generateId(),
        canvasSize: canvasSize,
        type: type,
        layers: [],
        updatedAt: DateTime.now(),
      );

  // Does any layer have entrance/exit animation defined?
  bool get hasAnimationLayers =>
      layers.any((l) => l.entranceAnimation != null || l.exitAnimation != null);

  CanvasDocument copyWith({
    String? templateId,
    Size? canvasSize,
    CanvasMediaType? type,
    List<Layer>? layers,
    AudioConfig? audio,
    VideoTrimConfig? videoTrim,
    DateTime? updatedAt,
  }) =>
      CanvasDocument(
        id: id,
        templateId: templateId ?? this.templateId,
        canvasSize: canvasSize ?? this.canvasSize,
        type: type ?? this.type,
        layers: layers ?? this.layers,
        audio: audio ?? this.audio,
        videoTrim: videoTrim ?? this.videoTrim,
        updatedAt: updatedAt ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'template_id': templateId,
    'schema_version': '1.0',
    'canvas_size': {
      'width': canvasSize.width,
      'height': canvasSize.height,
    },
    'type': type.name,
    'layers': layers.map((l) => l.toJson()).toList(),
    'audio': audio?.toJson(),
    'video_trim': videoTrim?.toJson(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory CanvasDocument.fromJson(Map<String, dynamic> json) => CanvasDocument(
    id: json['id'] as String,
    templateId: json['template_id'] as String?,
    canvasSize: Size(
      (json['canvas_size']['width'] as num).toDouble(),
      (json['canvas_size']['height'] as num).toDouble(),
    ),
    type: CanvasMediaType.values.byName(json['type'] as String),
    layers: (json['layers'] as List)
        .map((l) => layerFromJson(l as Map<String, dynamic>))
        .toList(),
    audio: json['audio'] != null
        ? AudioConfig.fromJson(json['audio'] as Map<String, dynamic>)
        : null,
    videoTrim: json['video_trim'] != null
        ? VideoTrimConfig.fromJson(json['video_trim'] as Map<String, dynamic>)
        : null,
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  static String _generateId() =>
      'doc_${DateTime.now().millisecondsSinceEpoch}';
}
