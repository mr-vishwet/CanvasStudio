import 'dart:async';
import 'dart:ui' as ui;
import 'package:canvas_studio/canvas_studio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../models/canvas_document.dart';
import '../state/canvas_controller.dart';
import '../rendering/canvas_painter.dart';
import '../rendering/layer_renderer.dart';
import '../utils/gesture_handler.dart';

class CanvasView extends StatefulWidget {
  final CanvasController controller;
  final Color backgroundColor;
  final bool showCheckerboard;

  const CanvasView({
    super.key,
    required this.controller,
    this.backgroundColor = Colors.white,
    this.showCheckerboard = false,
  });

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  late GestureHandler _gestureHandler;
  final TransformationController _transformController = TransformationController();
  Offset _canvasOrigin = Offset.zero;
  final GlobalKey _canvasKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _gestureHandler = GestureHandler(controller: widget.controller);
    widget.controller.addListener(_onControllerChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLayerImages());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _transformController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
    _loadLayerImages();
  }

  void _loadLayerImages() {
    for (final layer in widget.controller.layers) {
      String? url;
      if (layer is ImageLayer) url = layer.resolvedSource;
      if (layer is StickerLayer) url = layer.stickerUrl;
      if (url == null || url.isEmpty) continue;
      if (LayerRenderer.hasCache(url)) continue;
      _fetchImage(url);
    }
  }

  Future<void> _fetchImage(String url) async {
    try {
      final imageProvider = url.startsWith('http')
          ? NetworkImage(url) as ImageProvider
          : AssetImage(url);
      final stream = imageProvider.resolve(ImageConfiguration.empty);
      final completer = Completer<ui.Image>();
      stream.addListener(ImageStreamListener((info, _) {
        if (!completer.isCompleted) completer.complete(info.image);
      }));
      final image = await completer.future;
      LayerRenderer.cacheImage(url, image);
      if (mounted) setState(() {});
    } catch (_) {}
  }

  void _updateCanvasOrigin() {
    final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      _canvasOrigin = box.localToGlobal(Offset.zero);
    }
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.controller.document;

    return ClipRect(
      child: InteractiveViewer(
        transformationController: _transformController,
        minScale: 0.3,
        maxScale: 5.0,
        onInteractionUpdate: (details) {
          _gestureHandler.canvasScale =
              _transformController.value.getMaxScaleOnAxis();
        },
        child: Center(
          child: _buildCanvas(doc),
        ),
      ),
    );
  }

  Widget _buildCanvas(CanvasDocument doc) {
    return GestureDetector(
      onTapUp: (d) {
        _updateCanvasOrigin();
        _gestureHandler.onTap(d.globalPosition, _canvasOrigin);
      },
      onDoubleTapDown: (d) {
        _updateCanvasOrigin();
        _gestureHandler.onDoubleTap(d.globalPosition, _canvasOrigin);
      },
      onScaleStart: (d) {
        _updateCanvasOrigin();
        _gestureHandler.onScaleStart(d, _canvasOrigin);
      },
      onScaleUpdate: (d) => _gestureHandler.onScaleUpdate(d, _canvasOrigin),
      onScaleEnd: (d) => _gestureHandler.onScaleEnd(d),
      child: RepaintBoundary(
        child: Container(
          key: _canvasKey,
          width: doc.canvasSize.width,
          height: doc.canvasSize.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRect(
            child: CustomPaint(
              size: doc.canvasSize,
              painter: CanvasPainter(
                document: doc,
                selection: widget.controller.selection,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
