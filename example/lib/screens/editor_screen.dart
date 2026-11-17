import 'package:flutter/material.dart';
import 'package:canvas_studio/canvas_studio.dart';
import '../providers/example_template_provider.dart';
import '../providers/example_audio_provider.dart';
import '../providers/example_sticker_provider.dart';
import 'brand_profile_screen.dart';
import 'export_result_screen.dart';

class EditorScreen extends StatefulWidget {
  final TemplateManifest template;
  final ExampleTemplateProvider templateProvider;
  final ExampleAudioProvider audioProvider;
  final ExampleStickerProvider stickerProvider;

  const EditorScreen({
    super.key,
    required this.template,
    required this.templateProvider,
    required this.audioProvider,
    required this.stickerProvider,
  });

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late CanvasController _controller;
  CanvasEditorConfig _config = CanvasEditorConfig.defaults;
  bool _isExporting = false;
  bool _useDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _controller = CanvasController.empty(
      canvasSize: template.canvasSize,
      type: template.type == 'video'
          ? CanvasMediaType.video
          : CanvasMediaType.image,
    );
    _loadTemplate();
  }

  Future<void> _loadTemplate() async {
    final manifest = await widget.templateProvider.fetchTemplateById(
      template.id,
    );
    if (manifest == null) return;

    // Convert template layers to SDK layers
    final layers = <Layer>[];
    for (final layerJson in manifest.layers) {
      try {
        final layer = layerFromJson(layerJson);
        layers.add(layer);
      } catch (e) {
        // Skip layers that fail to parse
      }
    }

    final doc = CanvasDocument(
      id: manifest.id,
      canvasSize: manifest.canvasSize,
      type: CanvasMediaType.values.byName(manifest.type),
      layers: layers,
      updatedAt: DateTime.now(),
    );

    _controller.loadDocument(doc);
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleExport(ExportFormat format) async {
    if (!_config.allowedExportFormats.contains(format)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${format.name} export not available'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isExporting = true);

    try {
      final exportConfig = _controller.buildExportConfig(
        format: format,
        applyWatermark: _config.applyWatermark,
      );

      if (exportConfig.outputType == ExportOutputType.staticImage) {
        final result = await ExportRenderer.renderToBytes(
          _controller.document,
          format,
        );
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExportResultScreen(
                imageBytes: result.bytes,
                filePath: result.suggestedFileName,
                format: format,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Video export requires FFmpeg setup'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  void _applyBrand() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BrandProfileScreen(
          controller: _controller,
          templateProvider: widget.templateProvider,
        ),
      ),
    );
  }

  void _toggleTheme() {
    setState(() => _useDarkTheme = !_useDarkTheme);
  }

  @override
  Widget build(BuildContext context) {
    final theme = _useDarkTheme
        ? CanvasEditorTheme(
            primaryColor: const Color(0xFF03DAC6),
            surfaceColor: const Color(0xFF121212),
            onSurfaceColor: const Color(0xFFFFFFFF),
            borderColor: const Color(0xFF333333),
            activeColor: const Color(0xFF03DAC6),
            disabledColor: const Color(0xFF666666),
          )
        : CanvasEditorTheme.light();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: _useDarkTheme
            ? const ColorScheme.dark(
                surface: Color(0xFF121212),
                onSurface: Color(0xFFFFFFFF),
              )
            : ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: _useDarkTheme
            ? const Color(0xFF121212)
            : const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(theme),
              Expanded(
                child: CanvasEditorWidget(
                  controller: _controller,
                  config: _config,
                  canvasBackground: _useDarkTheme
                      ? const Color(0xFF1A1A2E)
                      : Colors.white,
                  onEditorReady: () {
                    debugPrint('Editor ready');
                  },
                  onExportImage: (result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Saved to ${result.friendlyPath}'),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  onExportError: (err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Export failed: $err'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                  onFeatureLocked: (feature) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${feature.name} requires upgrade'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                  onSaveDraft: () async {
                    final json = _controller.toJson();
                    debugPrint('Draft saved: $json');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Draft saved')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(CanvasEditorTheme theme) {
    return Container(
      height: theme.toolbarHeight,
      color: theme.surfaceColor,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
            color: theme.onSurfaceColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.template.name,
              style: TextStyle(
                color: theme.onSurfaceColor,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(Icons.undo, color: theme.onSurfaceColor),
            onPressed: _controller.canUndo ? _controller.undo : null,
            tooltip: 'Undo',
          ),
          IconButton(
            icon: Icon(Icons.redo, color: theme.onSurfaceColor),
            onPressed: _controller.canRedo ? _controller.redo : null,
            tooltip: 'Redo',
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.auto_awesome, color: theme.activeColor),
            onPressed: _applyBrand,
            tooltip: 'Brand Fill',
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              _useDarkTheme ? Icons.light_mode : Icons.dark_mode,
              color: theme.onSurfaceColor,
            ),
            onPressed: _toggleTheme,
            tooltip: 'Toggle Theme',
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: _isExporting ? null : () => _handleExport(ExportFormat.png),
            icon: _isExporting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download, size: 18),
            label: Text(_isExporting ? 'Exporting...' : 'Export'),
            style: FilledButton.styleFrom(
              backgroundColor: theme.activeColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
