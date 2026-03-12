import 'package:flutter/painting.dart';
import '../models/export/export_config.dart';

enum EditorFeature {
  removeBackground,
  videoExport,
  unlimitedAudio,
  animations,
  effects,
  brandFill,
  stickers,
  shapes,
  layerPanel,
}

class CanvasEditorConfig {
  final bool enableUndo;
  final bool enableRedo;
  final bool enableLayerPanel;
  final bool enableSnapLines;
  final bool enableBrandFill;
  final bool enableAudio;
  final bool enableVideoExport;
  final bool enableBackgroundRemoval;
  final bool applyWatermark;

  final int maxLayers;
  final int maxUndoSteps;
  final double minFontSize;
  final double maxFontSize;
  final double snapThreshold;

  final List<ExportFormat> allowedExportFormats;
  final Set<EditorFeature> disabledFeatures;

  const CanvasEditorConfig({
    this.enableUndo = true,
    this.enableRedo = true,
    this.enableLayerPanel = true,
    this.enableSnapLines = true,
    this.enableBrandFill = true,
    this.enableAudio = true,
    this.enableVideoExport = true,
    this.enableBackgroundRemoval = true,
    this.applyWatermark = false,
    this.maxLayers = 20,
    this.maxUndoSteps = 50,
    this.minFontSize = 8.0,
    this.maxFontSize = 200.0,
    this.snapThreshold = 8.0,
    this.allowedExportFormats = const [ExportFormat.png, ExportFormat.jpg, ExportFormat.mp4],
    this.disabledFeatures = const {},
  });

  bool isFeatureEnabled(EditorFeature feature) =>
      !disabledFeatures.contains(feature);

  static const CanvasEditorConfig defaults = CanvasEditorConfig();

  static const CanvasEditorConfig imageOnly = CanvasEditorConfig(
    enableAudio: false,
    enableVideoExport: false,
    allowedExportFormats: [ExportFormat.png, ExportFormat.jpg],
    disabledFeatures: {
      EditorFeature.videoExport,
      EditorFeature.unlimitedAudio,
      EditorFeature.animations,
    },
  );
}
