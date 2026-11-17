import 'package:flutter/material.dart';
import '../../models/layer/layers.dart';
import '../../state/canvas_controller.dart';

typedef LayerBuilder = Widget Function(Layer layer, CanvasController controller);
typedef LayerEditorBuilder = Widget Function(TextLayer layer, CanvasController controller);
typedef ExportResultBuilder = Widget Function(dynamic result);
typedef FeatureLockedBuilder = Widget Function(dynamic feature);
typedef CustomSlotBuilder = Widget Function(String slotName, Map<String, dynamic>? params);

class SlotOverrides {
  final LayerBuilder? layerCardBuilder;
  final LayerEditorBuilder? textEditorBuilder;
  final ExportResultBuilder? exportResultBuilder;
  final FeatureLockedBuilder? featureLockedBuilder;
  final CustomSlotBuilder? customSlotBuilder;

  const SlotOverrides({
    this.layerCardBuilder,
    this.textEditorBuilder,
    this.exportResultBuilder,
    this.featureLockedBuilder,
    this.customSlotBuilder,
  });

  SlotOverrides copyWith({
    LayerBuilder? layerCardBuilder,
    LayerEditorBuilder? textEditorBuilder,
    ExportResultBuilder? exportResultBuilder,
    FeatureLockedBuilder? featureLockedBuilder,
    CustomSlotBuilder? customSlotBuilder,
  }) =>
      SlotOverrides(
        layerCardBuilder: layerCardBuilder ?? this.layerCardBuilder,
        textEditorBuilder: textEditorBuilder ?? this.textEditorBuilder,
        exportResultBuilder: exportResultBuilder ?? this.exportResultBuilder,
        featureLockedBuilder: featureLockedBuilder ?? this.featureLockedBuilder,
        customSlotBuilder: customSlotBuilder ?? this.customSlotBuilder,
      );
}
