import 'package:flutter/material.dart';
import '../models/export/export_config.dart';
import '../models/layer/layers.dart';
import '../state/canvas_controller.dart';
import '../modules/export/export_handler.dart';
import 'canvas_view.dart';
import 'canvas_editor_config.dart';
import 'toolbars/main_toolbar.dart';

class CanvasEditorWidget extends StatefulWidget {
  final CanvasController controller;
  final CanvasEditorConfig config;

  // Top bar slot overrides
  final Widget? customTopBar;
  final Widget? exportButtonOverride;

  // Lifecycle callbacks
  final VoidCallback? onEditorReady;
  final void Function(Layer)? onLayerAdded;
  final void Function(Layer)? onLayerDeleted;
  final void Function(Layer)? onLayerSelected;
  final void Function(ExportHandlerResult)? onExportImage;
  final void Function(String error)? onExportError;
  final void Function(Layer)? onLayerDoubleTap;
  final VoidCallback? onSaveDraft;

  // Feature locked callback
  final void Function(EditorFeature)? onFeatureLocked;

  final Color canvasBackground;

  const CanvasEditorWidget({
    super.key,
    required this.controller,
    this.config = CanvasEditorConfig.defaults,
    this.customTopBar,
    this.exportButtonOverride,
    this.onEditorReady,
    this.onLayerAdded,
    this.onLayerDeleted,
    this.onLayerSelected,
    this.onExportImage,
    this.onExportError,
    this.onLayerDoubleTap,
    this.onSaveDraft,
    this.onFeatureLocked,
    this.canvasBackground = Colors.white,
  });

  @override
  State<CanvasEditorWidget> createState() => _CanvasEditorWidgetState();
}

class _CanvasEditorWidgetState extends State<CanvasEditorWidget> {
  bool _isExporting = false;

  CanvasController get _controller => widget.controller;
  CanvasEditorConfig get _config => widget.config;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onEditorReady?.call();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _handleExport(ExportFormat format) async {
    if (!_config.allowedExportFormats.contains(format)) {
      widget.onFeatureLocked?.call(EditorFeature.videoExport);
      return;
    }

    setState(() => _isExporting = true);

    try {
      final exportConfig = _controller.buildExportConfig(
        format: format,
        applyWatermark: _config.applyWatermark,
      );
      final result = await ExportHandler.export(exportConfig);
      widget.onExportImage?.call(result);
    } catch (e) {
      widget.onExportError?.call(e.toString());
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(context),
        Expanded(
          child: Stack(
            children: [
              _buildCanvasArea(),
              if (_isExporting) _buildExportOverlay(),
            ],
          ),
        ),
        MainToolbar(
          controller: _controller,
          config: _config,
          onExport: _handleExport,
          onFeatureLocked: widget.onFeatureLocked,
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    if (widget.customTopBar != null) return widget.customTopBar!;

    return Container(
      height: 56,
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          // Undo
          if (_config.enableUndo)
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: _controller.canUndo ? _controller.undo : null,
              tooltip: 'Undo',
            ),
          // Redo
          if (_config.enableRedo)
            IconButton(
              icon: const Icon(Icons.redo),
              onPressed: _controller.canRedo ? _controller.redo : null,
              tooltip: 'Redo',
            ),
          const Spacer(),
          // Layer count indicator
          if (_controller.layers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '${_controller.layers.length} layers',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          // Save draft
          if (widget.onSaveDraft != null)
            IconButton(
              icon: const Icon(Icons.save_outlined),
              onPressed: widget.onSaveDraft,
              tooltip: 'Save draft',
            ),
          // Export button
          widget.exportButtonOverride ??
              _buildExportButton(context),
        ],
      ),
    );
  }

  Widget _buildExportButton(BuildContext context) {
    return FilledButton.icon(
      onPressed: _isExporting ? null : () => _handleExport(ExportFormat.png),
      icon: _isExporting
          ? const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
          : const Icon(Icons.download, size: 18),
      label: Text(_isExporting ? 'Exporting...' : 'Export'),
    );
  }

  Widget _buildCanvasArea() {
    return CanvasView(
      controller: _controller,
      backgroundColor: widget.canvasBackground,
    );
  }

  Widget _buildExportOverlay() {
    return Container(
      color: Colors.black26,
      child: const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Exporting...'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
