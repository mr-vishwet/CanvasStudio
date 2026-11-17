import 'package:flutter/material.dart';
import '../../models/effect_config.dart';

class EffectPicker extends StatelessWidget {
  final EffectConfig effect;
  final ValueChanged<EffectConfig> onEffectChanged;

  const EffectPicker({
    super.key,
    required this.effect,
    required this.onEffectChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Effects'),
        Slider(
          value: effect.brightness,
          min: -1.0,
          max: 1.0,
          onChanged: (v) => onEffectChanged(effect.copyWith(brightness: v)),
        ),
        Slider(
          value: effect.contrast,
          min: -1.0,
          max: 1.0,
          onChanged: (v) => onEffectChanged(effect.copyWith(contrast: v)),
        ),
        Slider(
          value: effect.saturation,
          min: -1.0,
          max: 1.0,
          onChanged: (v) => onEffectChanged(effect.copyWith(saturation: v)),
        ),
        Slider(
          value: effect.blurRadius,
          min: 0.0,
          max: 20.0,
          onChanged: (v) => onEffectChanged(effect.copyWith(blurRadius: v)),
        ),
        Slider(
          value: effect.vignette,
          min: 0.0,
          max: 1.0,
          onChanged: (v) => onEffectChanged(effect.copyWith(vignette: v)),
        ),
      ],
    );
  }
}
