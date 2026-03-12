import 'package:flutter/painting.dart';
import 'layer.dart';
import '../animation_config.dart';

class StickerLayer extends Layer {
  final String stickerId;
  final String stickerUrl;
  final String? category;

  StickerLayer({
    required super.id,
    required super.name,
    required super.position,
    required super.size,
    required this.stickerId,
    required this.stickerUrl,
    this.category,
    super.rotation,
    super.opacity,
    super.isVisible,
    super.isLocked,
    super.placeholderName,
    super.entranceAnimation,
    super.exitAnimation,
  }) : super(type: LayerType.sticker);

  @override
  StickerLayer copyWith({
    String? name,
    Offset? position,
    Size? size,
    double? rotation,
    double? opacity,
    bool? isVisible,
    bool? isLocked,
    String? placeholderName,
    AnimationConfig? entranceAnimation,
    AnimationConfig? exitAnimation,
    String? stickerUrl,
    String? category,
  }) =>
      StickerLayer(
        id: id,
        name: name ?? this.name,
        position: position ?? this.position,
        size: size ?? this.size,
        rotation: rotation ?? this.rotation,
        opacity: opacity ?? this.opacity,
        isVisible: isVisible ?? this.isVisible,
        isLocked: isLocked ?? this.isLocked,
        placeholderName: placeholderName ?? this.placeholderName,
        entranceAnimation: entranceAnimation ?? this.entranceAnimation,
        exitAnimation: exitAnimation ?? this.exitAnimation,
        stickerId: stickerId,
        stickerUrl: stickerUrl ?? this.stickerUrl,
        category: category ?? this.category,
      );

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'sticker_id': stickerId,
    'sticker_url': stickerUrl,
    'category': category,
  };

  factory StickerLayer.fromJson(Map<String, dynamic> json) => StickerLayer(
    id: json['id'] as String,
    name: json['name'] as String,
    position: Layer.offsetFromJson(json['position'] as Map<String, dynamic>),
    size: Layer.sizeFromJson(json['size'] as Map<String, dynamic>),
    rotation: (json['rotation'] as num?)?.toDouble() ?? 0,
    opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
    isVisible: json['is_visible'] as bool? ?? true,
    isLocked: json['is_locked'] as bool? ?? false,
    placeholderName: json['placeholder_name'] as String?,
    stickerId: json['sticker_id'] as String,
    stickerUrl: json['sticker_url'] as String,
    category: json['category'] as String?,
  );
}
