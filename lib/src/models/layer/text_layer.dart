import 'package:flutter/painting.dart';
import 'layer.dart';
import '../animation_config.dart';

enum TextAlignment { left, center, right }
enum FontWeight { thin, light, regular, medium, semiBold, bold, extraBold }

class TextLayer extends Layer {
  String text;
  String fontFamily;
  double fontSize;
  FontWeight fontWeight;
  Color color;
  TextAlignment alignment;
  bool isIndicScript;

  TextLayer({
    required super.id,
    required super.name,
    required super.position,
    required super.size,
    required this.text,
    required this.fontFamily,
    required this.fontSize,
    this.fontWeight = FontWeight.regular,
    this.color = const Color(0xFFFFFFFF),
    this.alignment = TextAlignment.center,
    this.isIndicScript = false,
    super.rotation,
    super.opacity,
    super.isVisible,
    super.isLocked,
    super.placeholderName,
    super.entranceAnimation,
    super.exitAnimation,
  }) : super(type: LayerType.text);

  @override
  TextLayer copyWith({
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
    String? text,
    String? fontFamily,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlignment? alignment,
    bool? isIndicScript,
  }) =>
      TextLayer(
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
        text: text ?? this.text,
        fontFamily: fontFamily ?? this.fontFamily,
        fontSize: fontSize ?? this.fontSize,
        fontWeight: fontWeight ?? this.fontWeight,
        color: color ?? this.color,
        alignment: alignment ?? this.alignment,
        isIndicScript: isIndicScript ?? this.isIndicScript,
      );

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'text': text,
    'font_family': fontFamily,
    'font_size': fontSize,
    'font_weight': fontWeight.name,
    'color': '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
    'alignment': alignment.name,
    'is_indic_script': isIndicScript,
  };

  factory TextLayer.fromJson(Map<String, dynamic> json) => TextLayer(
    id: json['id'] as String,
    name: json['name'] as String,
    position: Layer.offsetFromJson(json['position'] as Map<String, dynamic>),
    size: Layer.sizeFromJson(json['size'] as Map<String, dynamic>),
    rotation: (json['rotation'] as num?)?.toDouble() ?? 0,
    opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
    isVisible: json['is_visible'] as bool? ?? true,
    isLocked: json['is_locked'] as bool? ?? false,
    placeholderName: json['placeholder_name'] as String?,
    entranceAnimation: json['entrance_animation'] != null
        ? AnimationConfig.fromJson(json['entrance_animation'] as Map<String, dynamic>)
        : null,
    exitAnimation: json['exit_animation'] != null
        ? AnimationConfig.fromJson(json['exit_animation'] as Map<String, dynamic>)
        : null,
    text: json['text'] as String? ?? '',
    fontFamily: json['font_family'] as String? ?? 'Roboto',
    fontSize: (json['font_size'] as num?)?.toDouble() ?? 24.0,
    fontWeight: FontWeight.values.byName(json['font_weight'] as String? ?? 'regular'),
    color: _colorFromHex(json['color'] as String? ?? '#FFFFFFFF'),
    alignment: TextAlignment.values.byName(json['alignment'] as String? ?? 'center'),
    isIndicScript: json['is_indic_script'] as bool? ?? false,
  );

  static Color _colorFromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
