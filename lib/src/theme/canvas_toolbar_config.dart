import 'package:flutter/material.dart';

class CanvasToolbarItem {
  final String id;
  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  const CanvasToolbarItem({
    required this.id,
    required this.label,
    required this.icon,
    this.enabled = true,
    this.onTap,
  });
}

class CanvasToolbarConfig {
  final List<CanvasToolbarItem> mainItems;
  final List<CanvasToolbarItem> textItems;
  final List<CanvasToolbarItem> imageItems;
  final List<CanvasToolbarItem> videoItems;
  final List<CanvasToolbarItem> animationItems;
  final bool showLabels;
  final double itemSize;
  final Color? activeColor;
  final Color? inactiveColor;

  const CanvasToolbarConfig({
    this.mainItems = const [],
    this.textItems = const [],
    this.imageItems = const [],
    this.videoItems = const [],
    this.animationItems = const [],
    this.showLabels = true,
    this.itemSize = 40.0,
    this.activeColor,
    this.inactiveColor,
  });

  CanvasToolbarItem? itemById(String id, List<CanvasToolbarItem> items) =>
      items.firstWhere((i) => i.id == id, orElse: () => throw StateError('Toolbar item $id not found'));
}
