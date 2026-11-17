import 'dart:ui';
import 'package:flutter/painting.dart';
import '../../models/effect_config.dart';

class EffectEngine {
  static ColorFilter colorFilter(EffectConfig effect) {
    final brightness = 1.0 + effect.brightness.clamp(-1.0, 1.0);
    final contrast = 1.0 + effect.contrast.clamp(-1.0, 1.0);
    return ColorFilter.matrix([
      contrast, 0, 0, 0, (brightness - 1) * 255,
      0, contrast, 0, 0, (brightness - 1) * 255,
      0, 0, contrast, 0, (brightness - 1) * 255,
      0, 0, 0, 1, 0,
    ]);
  }

  static ImageFilter blurFilter(double blurRadius) =>
      blurRadius <= 0.0
          ? ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0)
          : ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius);

  static bool needsShader(EffectConfig effect) =>
      effect.saturation != 0.0 || effect.vignette != 0.0;
}
