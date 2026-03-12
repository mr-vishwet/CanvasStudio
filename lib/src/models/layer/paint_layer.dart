import 'package:flutter/painting.dart';
import 'layer.dart';
import '../animation_config.dart';

enum BrushType { pen, marker, pencil, eraser }

class PaintStroke {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final BrushType brushType;

  const PaintStroke({
    required this.points,
    required this.color,
    required this.strokeWidth,
    required this.brushType,
  });

  Map<String, dynamic> toJson() => {
    'points': points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
    'color': '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
    'stroke_width': strokeWidth,
    'brush_type': brushType.name,
  };

  factory PaintStroke.fromJson(Map<String, dynamic> json) {
    final hex = json['color'] as String? ?? '#FF000000';
    final buffer = StringBuffer();
    if (hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return PaintStroke(
      points: (json['points'] as List)
          .map((p) => Offset((p['x'] as num).toDouble(), (p['y'] as num).toDouble()))
          .toList(),
      color: Color(int.parse(buffer.toString(), radix: 16)),
      strokeWidth: (json['stroke_width'] as num).toDouble(),
      brushType: BrushType.values.byName(json['brush_type'] as String? ?? 'pen'),
    );
  }
}

class PaintLayer extends Layer {
  List<PaintStroke> strokes;

  PaintLayer({
    required super.id,
    required super.name,
    required super.position,
    required super.size,
    List<PaintStroke>? strokes,
    super.rotation,
    super.opacity,
    super.isVisible,
    super.isLocked,
    super.placeholderName,
    super.entranceAnimation,
    super.exitAnimation,
  })  : strokes = strokes ?? [],
        super(type: LayerType.paint);

  @override
  PaintLayer copyWith({
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
    List<PaintStroke>? strokes,
  }) =>
      PaintLayer(
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
        strokes: strokes ?? List.from(this.strokes),
      );

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'strokes': strokes.map((s) => s.toJson()).toList(),
  };

  factory PaintLayer.fromJson(Map<String, dynamic> json) => PaintLayer(
    id: json['id'] as String,
    name: json['name'] as String,
    position: Layer.offsetFromJson(json['position'] as Map<String, dynamic>),
    size: Layer.sizeFromJson(json['size'] as Map<String, dynamic>),
    rotation: (json['rotation'] as num?)?.toDouble() ?? 0,
    opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
    isVisible: json['is_visible'] as bool? ?? true,
    isLocked: json['is_locked'] as bool? ?? false,
    strokes: (json['strokes'] as List?)
        ?.map((s) => PaintStroke.fromJson(s as Map<String, dynamic>))
        .toList() ??
        [],
  );
}
