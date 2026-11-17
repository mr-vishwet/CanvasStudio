import 'package:flutter/material.dart';

class CanvasEditorLocalizations {
  static const CanvasEditorLocalizations _default = CanvasEditorLocalizations._();

  const CanvasEditorLocalizations._();

  static CanvasEditorLocalizations of(BuildContext context) =>
      Localizations.of<CanvasEditorLocalizations>(context, CanvasEditorLocalizations) ?? _default;

  String get undo => 'Undo';
  String get redo => 'Redo';
  String get export => 'Export';
  String get saveDraft => 'Save draft';
  String get layers => 'Layers';
  String get addLayer => 'Add layer';
  String get deleteLayer => 'Delete layer';
  String get duplicateLayer => 'Duplicate';
  String get textTool => 'Text';
  String get imageTool => 'Image';
  String get shapeTool => 'Shape';
  String get stickerTool => 'Sticker';
  String get paintTool => 'Paint';
  String get audioTool => 'Audio';
  String get videoTool => 'Video';
  String get cropTool => 'Crop';
  String get filterTool => 'Filter';
  String get removeBg => 'Remove background';
  String get brandFill => 'Brand fill';
  String get settings => 'Settings';
  String get close => 'Close';
  String get check => 'OK';
  String get more => 'More';
  String get exporting => 'Exporting...';
  String get featureLocked => 'Feature locked';
  String get layerCount => 'layers';
  String get selectAudio => 'Select audio';
  String get selectSticker => 'Select sticker';
  String get selectFont => 'Select font';
  String get selectColor => 'Select color';
  String get enterText => 'Enter text';
  String get tapToEdit => 'Tap to edit';
  String get noLayers => 'No layers';
  String get templateLoaded => 'Template loaded';
  String get draftSaved => 'Draft saved';
}
