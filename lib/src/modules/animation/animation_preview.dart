import '../../models/canvas_document.dart';
import '../../models/layer/text_layer.dart';
import '../../models/animation_config.dart';

class AnimationPreview {
  static bool hasAnimations(CanvasDocument doc) =>
      doc.layers.any((l) => l.entranceAnimation != null || l.exitAnimation != null);

  static List<AnimationConfig> getLayerAnimations(TextLayer layer) {
    final configs = <AnimationConfig>[];
    if (layer.entranceAnimation != null) configs.add(layer.entranceAnimation!);
    if (layer.exitAnimation != null) configs.add(layer.exitAnimation!);
    return configs;
  }

  static Duration totalDuration(CanvasDocument doc) {
    double maxSeconds = 0;
    for (final layer in doc.layers) {
      if (layer is TextLayer) {
        if (layer.entranceAnimation != null) {
          final end = layer.entranceAnimation!.startTimeSeconds +
              layer.entranceAnimation!.durationSeconds;
          if (end > maxSeconds) maxSeconds = end;
        }
        if (layer.exitAnimation != null) {
          final end = layer.exitAnimation!.startTimeSeconds +
              layer.exitAnimation!.durationSeconds;
          if (end > maxSeconds) maxSeconds = end;
        }
      }
    }
    return Duration(seconds: maxSeconds.toInt());
  }
}
