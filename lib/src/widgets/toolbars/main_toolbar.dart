import 'package:canvas_studio/canvas_studio.dart';
import 'package:flutter/material.dart';
import '../../models/export/export_config.dart';
import '../../state/canvas_controller.dart';
import '../canvas_editor_config.dart';

class MainToolbar extends StatelessWidget {
  final CanvasController controller;
  final CanvasEditorConfig config;
  final void Function(ExportFormat) onExport;
  final void Function(EditorFeature)? onFeatureLocked;

  const MainToolbar({
    super.key,
    required this.controller,
    required this.config,
    required this.onExport,
    this.onFeatureLocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          _ToolbarItem(
            icon: Icons.text_fields,
            label: 'Text',
            onTap: () => _onTapText(context),
          ),
          _ToolbarItem(
            icon: Icons.image_outlined,
            label: 'Image',
            onTap: () => _onTapImage(context),
          ),
          _ToolbarItem(
            icon: Icons.auto_awesome,
            label: 'Stickers',
            onTap: () => _checkFeature(context, EditorFeature.stickers, () {}),
          ),
          _ToolbarItem(
            icon: Icons.format_shapes_outlined,
            label: 'Shapes',
            onTap: () => _checkFeature(context, EditorFeature.shapes, () {}),
          ),
          _ToolbarItem(
            icon: Icons.tune,
            label: 'Effects',
            onTap: () => _checkFeature(context, EditorFeature.effects, () {}),
          ),
          _ToolbarItem(
            icon: Icons.music_note_outlined,
            label: 'Audio',
            onTap: () => _checkFeature(context, EditorFeature.unlimitedAudio, () {}),
          ),
          if (config.enableLayerPanel)
            _ToolbarItem(
              icon: Icons.layers_outlined,
              label: 'Layers',
              onTap: () => _showLayersPanel(context),
            ),
          if (config.enableBrandFill)
            _ToolbarItem(
              icon: Icons.business_outlined,
              label: 'Brand',
              onTap: () => _checkFeature(context, EditorFeature.brandFill, () {}),
            ),
          _ToolbarItem(
            icon: Icons.photo_size_select_large_outlined,
            label: 'Export MP4',
            onTap: () => _checkFeature(
              context,
              EditorFeature.videoExport,
                  () => onExport(ExportFormat.mp4),
            ),
          ),
        ],
      ),
    );
  }

  void _checkFeature(
      BuildContext context,
      EditorFeature feature,
      VoidCallback onAllowed,
      ) {
    if (!config.isFeatureEnabled(feature)) {
      onFeatureLocked?.call(feature);
      return;
    }
    onAllowed();
  }

  void _onTapText(BuildContext context) {
    if (controller.layers.length >= config.maxLayers) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum ${config.maxLayers} layers reached')),
      );
      return;
    }
    // Phase 2: opens TextEditSheet
    // For now: add a default TextLayer at canvas center
    final canvasSize = controller.document.canvasSize;
    controller.addLayer(TextLayer(
      id: 'text_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Text',
      position: Offset(canvasSize.width / 4, canvasSize.height / 2 - 30),
      size: Size(canvasSize.width / 2, 60),
      text: 'Tap to edit',
      fontFamily: 'Roboto',
      fontSize: 32,
    ));
  }

  void _onTapImage(BuildContext context) {
    // Phase 2: opens ImagePicker
    // Shell placeholder — shows snackbar for now
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image picker — Phase 2')),
    );
  }

  void _showLayersPanel(BuildContext context) {
    // Phase 2: opens LayerPanel bottom sheet
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Layer panel — Phase 2')),
    );
  }
}

class _ToolbarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _ToolbarItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: color),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
