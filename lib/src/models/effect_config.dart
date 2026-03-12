class EffectConfig {
  final double brightness;  // -1.0 to 1.0
  final double contrast;    // -1.0 to 1.0
  final double saturation;  // -1.0 to 1.0
  final double blurRadius;  //  0.0 to 20.0
  final double vignette;    //  0.0 to 1.0

  const EffectConfig({
    this.brightness = 0.0,
    this.contrast = 0.0,
    this.saturation = 0.0,
    this.blurRadius = 0.0,
    this.vignette = 0.0,
  });

  bool get isIdentity =>
      brightness == 0.0 &&
          contrast == 0.0 &&
          saturation == 0.0 &&
          blurRadius == 0.0 &&
          vignette == 0.0;

  EffectConfig copyWith({
    double? brightness,
    double? contrast,
    double? saturation,
    double? blurRadius,
    double? vignette,
  }) =>
      EffectConfig(
        brightness: brightness ?? this.brightness,
        contrast: contrast ?? this.contrast,
        saturation: saturation ?? this.saturation,
        blurRadius: blurRadius ?? this.blurRadius,
        vignette: vignette ?? this.vignette,
      );

  Map<String, dynamic> toJson() => {
    'brightness': brightness,
    'contrast': contrast,
    'saturation': saturation,
    'blur_radius': blurRadius,
    'vignette': vignette,
  };

  factory EffectConfig.fromJson(Map<String, dynamic> json) => EffectConfig(
    brightness: (json['brightness'] as num?)?.toDouble() ?? 0.0,
    contrast: (json['contrast'] as num?)?.toDouble() ?? 0.0,
    saturation: (json['saturation'] as num?)?.toDouble() ?? 0.0,
    blurRadius: (json['blur_radius'] as num?)?.toDouble() ?? 0.0,
    vignette: (json['vignette'] as num?)?.toDouble() ?? 0.0,
  );

  static const EffectConfig identity = EffectConfig();
}
