import '../../models/layer/text_layer.dart';
import '../../models/animation_config.dart';

class TextEditController {
  final TextLayer _layer;

  TextEditController(this._layer);

  TextLayer get layer => _layer;

  String get text => _layer.text;
  set text(String value) => _layer.text = value;

  String get fontFamily => _layer.fontFamily;
  set fontFamily(String value) => _layer.fontFamily = value;

  double get fontSize => _layer.fontSize;
  set fontSize(double value) => _layer.fontSize = value;

  AnimationConfig? get entranceAnimation => _layer.entranceAnimation;
  set entranceAnimation(AnimationConfig? value) => _layer.entranceAnimation = value;

  AnimationConfig? get exitAnimation => _layer.exitAnimation;
  set exitAnimation(AnimationConfig? value) => _layer.exitAnimation = value;

  void applyAnimation(AnimationType type, {double start = 0, double duration = 1}) {
    _layer.entranceAnimation = AnimationConfig(type: type, startTimeSeconds: start, durationSeconds: duration);
  }

  void clearAnimation() {
    _layer.entranceAnimation = null;
    _layer.exitAnimation = null;
  }
}
