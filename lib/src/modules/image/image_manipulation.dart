import '../../models/layer/image_layer.dart';
import '../../models/effect_config.dart';

class ImageManipulation {
  static ImageLayer applyEffect(ImageLayer layer, EffectConfig effect) =>
      layer.copyWith(effects: effect);

  static ImageLayer resetEffects(ImageLayer layer) =>
      layer.copyWith(effects: EffectConfig.identity);

  static bool hasEffects(ImageLayer layer) => !layer.effects.isIdentity;
}
