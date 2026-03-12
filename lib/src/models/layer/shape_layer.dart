import 'package:flutter/painting.dart';
import 'layer.dart';
import '../animation_config.dart';

enum ShapeType { rectangle, circle, triangle, line, polygon }

class ShapeLayer extends Layer {
  ShapeType shapeType;
  Color fillColor;
  Color strokeColor;
  double strokeWidth;
  double cornerRadius;

  ShapeLayer({
    required super.id,
    required super.name,
    required super.position,
    required super.size,
    required this.shapeType,
    this.fillColor = const Color(0xFF2196F3),
    this.strokeColor = const Color(0xFF000000),
    this.strokeWidth = 0.0,
    this.cornerRadius = 0.0,
    super.rotation,
    super.opacity,
    super.isVisible,
    super.isLocked,
    super.placeholderName,
    super.entranceAnimation,
    super.exitAnimation,
  }) : super(type: LayerType.shape);

  @override
  ShapeLayer copyWith({
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
    ShapeType? shapeType,
    Color? fillColor,
    Color? strokeColor,
    double? strokeWidth,
    double? cornerRadius,
  }) =>
      ShapeLayer(
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
        shapeType: shapeType ?? this.shapeType,
        fillColor: fillColor ?? this.fillColor,
        strokeColor: strokeColor ?? this.strokeColor,
        strokeWidth: strokeWidth ?? this.strokeWidth,
        cornerRadius: cornerRadius ?? this.cornerRadius,
      );

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'shape_type': shapeType.name,
    'fill_color': '#${fillColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
    'stroke_color': '#${strokeColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
    'stroke_width': strokeWidth,
    'corner_radius': cornerRadius,
  };

  factory ShapeLayer.fromJson(Map<String, dynamic> json) => ShapeLayer(
    id: json['id'] as String,
    name: json['name'] as String,
    position: Layer.offsetFromJson(json['position'] as Map<String, dynamic>),
    size: Layer.sizeFromJson(json['size'] as Map<String, dynamic>),
    rotation: (json['rotation'] as num?)?.toDouble() ?? 0,
    opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
    isVisible: json['is_visible'] as bool? ?? true,
    isLocked: json['is_locked'] as bool? ?? false,
    placeholderName: json['placeholder_name'] as String?,
    shapeType: ShapeType.values.byName(json['shape_type'] as String),
    fillColor: _colorFromHex(json['fill_color'] as String? ?? '#FF2196F3'),
    strokeColor: _colorFromHex(json['stroke_color'] as String? ?? '#FF000000'),
    strokeWidth: (json['stroke_width'] as num?)?.toDouble() ?? 0.0,
    cornerRadius: (json['corner_radius'] as num?)?.toDouble() ?? 0.0,
  );

  static Color _colorFromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
