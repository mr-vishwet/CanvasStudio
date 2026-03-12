import 'package:flutter/painting.dart';
import 'layer.dart';
import '../animation_config.dart';
import '../effect_config.dart';

class ImageLayer extends Layer {
  String? imageUrl;
  String? localPath;
  Rect? cropRect;
  EffectConfig effects;
  bool hasTransparentBg;

  ImageLayer({
    required super.id,
    required super.name,
    required super.position,
    required super.size,
    this.imageUrl,
    this.localPath,
    this.cropRect,
    EffectConfig? effects,
    this.hasTransparentBg = false,
    super.rotation,
    super.opacity,
    super.isVisible,
    super.isLocked,
    super.placeholderName,
    super.entranceAnimation,
    super.exitAnimation,
  })  : effects = effects ?? const EffectConfig(),
        super(type: LayerType.image);

  String? get resolvedSource => localPath ?? imageUrl;

  @override
  ImageLayer copyWith({
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
    String? imageUrl,
    String? localPath,
    Rect? cropRect,
    EffectConfig? effects,
    bool? hasTransparentBg,
  }) =>
      ImageLayer(
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
        imageUrl: imageUrl ?? this.imageUrl,
        localPath: localPath ?? this.localPath,
        cropRect: cropRect ?? this.cropRect,
        effects: effects ?? this.effects,
        hasTransparentBg: hasTransparentBg ?? this.hasTransparentBg,
      );

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'image_url': imageUrl,
    'local_path': localPath,
    'crop_rect': cropRect != null
        ? {
      'left': cropRect!.left,
      'top': cropRect!.top,
      'right': cropRect!.right,
      'bottom': cropRect!.bottom,
    }
        : null,
    'effects': effects.toJson(),
    'has_transparent_bg': hasTransparentBg,
  };

  factory ImageLayer.fromJson(Map<String, dynamic> json) {
    Rect? cropRect;
    if (json['crop_rect'] != null) {
      final c = json['crop_rect'] as Map<String, dynamic>;
      cropRect = Rect.fromLTRB(
        (c['left'] as num).toDouble(),
        (c['top'] as num).toDouble(),
        (c['right'] as num).toDouble(),
        (c['bottom'] as num).toDouble(),
      );
    }
    return ImageLayer(
      id: json['id'] as String,
      name: json['name'] as String,
      position: Layer.offsetFromJson(json['position'] as Map<String, dynamic>),
      size: Layer.sizeFromJson(json['size'] as Map<String, dynamic>),
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      isVisible: json['is_visible'] as bool? ?? true,
      isLocked: json['is_locked'] as bool? ?? false,
      placeholderName: json['placeholder_name'] as String?,
      imageUrl: json['image_url'] as String?,
      localPath: json['local_path'] as String?,
      cropRect: cropRect,
      effects: json['effects'] != null
          ? EffectConfig.fromJson(json['effects'] as Map<String, dynamic>)
          : const EffectConfig(),
      hasTransparentBg: json['has_transparent_bg'] as bool? ?? false,
    );
  }
}
