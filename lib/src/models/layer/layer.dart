import 'package:flutter/painting.dart';
import '../animation_config.dart';

export 'text_layer.dart';
export 'image_layer.dart';
export 'shape_layer.dart';
export 'sticker_layer.dart';
export 'paint_layer.dart';

enum LayerType { text, image, shape, sticker, paint }

abstract class Layer {
  final String id;
  final LayerType type;
  String name;
  Offset position;
  Size size;
  double rotation;
  double opacity;
  bool isVisible;
  bool isLocked;
  String? placeholderName;
  AnimationConfig? entranceAnimation;
  AnimationConfig? exitAnimation;

  Layer({
    required this.id,
    required this.type,
    required this.name,
    required this.position,
    required this.size,
    this.rotation = 0,
    this.opacity = 1.0,
    this.isVisible = true,
    this.isLocked = false,
    this.placeholderName,
    this.entranceAnimation,
    this.exitAnimation,
  });

  Layer copyWith({
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
  });

  Map<String, dynamic> toJson();

  Map<String, dynamic> baseToJson() => {
    'id': id,
    'type': type.name,
    'name': name,
    'position': {'x': position.dx, 'y': position.dy},
    'size': {'width': size.width, 'height': size.height},
    'rotation': rotation,
    'opacity': opacity,
    'is_visible': isVisible,
    'is_locked': isLocked,
    'placeholder_name': placeholderName,
    'entrance_animation': entranceAnimation?.toJson(),
    'exit_animation': exitAnimation?.toJson(),
  };

  static Offset offsetFromJson(Map<String, dynamic> j) =>
      Offset((j['x'] as num).toDouble(), (j['y'] as num).toDouble());

  static Size sizeFromJson(Map<String, dynamic> j) =>
      Size((j['width'] as num).toDouble(), (j['height'] as num).toDouble());
}
