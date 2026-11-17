import 'package:flutter/material.dart';

class CanvasEditorIcons {
  final IconData addLayer;
  final IconData deleteLayer;
  final IconData duplicateLayer;
  final IconData bringToFront;
  final IconData sendToBack;
  final IconData undo;
  final IconData redo;
  final IconData export;
  final IconData text;
  final IconData image;
  final IconData shape;
  final IconData sticker;
  final IconData paint;
  final IconData audio;
  final IconData video;
  final IconData crop;
  final IconData filter;
  final IconData removeBg;
  final IconData brandFill;
  final IconData layers;
  final IconData settings;
  final IconData close;
  final IconData check;
  final IconData more;

  const CanvasEditorIcons({
    this.addLayer = Icons.add,
    this.deleteLayer = Icons.delete_outline,
    this.duplicateLayer = Icons.content_copy,
    this.bringToFront = Icons.move_to_inbox,
    this.sendToBack = Icons.move_to_inbox,
    this.undo = Icons.undo,
    this.redo = Icons.redo,
    this.export = Icons.download,
    this.text = Icons.text_fields,
    this.image = Icons.image,
    this.shape = Icons.format_shapes,
    this.sticker = Icons.emoji_objects,
    this.paint = Icons.brush,
    this.audio = Icons.audiotrack,
    this.video = Icons.videocam,
    this.crop = Icons.crop,
    this.filter = Icons.filter_alt,
    this.removeBg = Icons.cut,
    this.brandFill = Icons.auto_awesome,
    this.layers = Icons.layers,
    this.settings = Icons.settings,
    this.close = Icons.close,
    this.check = Icons.check,
    this.more = Icons.more_vert,
  });

  IconData getIcon(String name) => switch (name) {
    'add_layer' => addLayer,
    'delete_layer' => deleteLayer,
    'duplicate_layer' => duplicateLayer,
    'bring_to_front' => bringToFront,
    'send_to_back' => sendToBack,
    'undo' => undo,
    'redo' => redo,
    'export' => export,
    'text' => text,
    'image' => image,
    'shape' => shape,
    'sticker' => sticker,
    'paint' => paint,
    'audio' => audio,
    'video' => video,
    'crop' => crop,
    'filter' => filter,
    'remove_bg' => removeBg,
    'brand_fill' => brandFill,
    'layers' => layers,
    'settings' => settings,
    'close' => close,
    'check' => check,
    'more' => more,
    _ => more,
  };
}
