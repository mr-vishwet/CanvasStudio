import 'dart:ui' as ui;
import 'package:flutter/painting.dart';
import '../models/layer/layers.dart';
import '../models/effect_config.dart';

class LayerRenderer {
  static final Map<String, ui.Image> _imageCache = {};

  static void render(Layer layer, Canvas canvas, {bool isExporting = false}) {
    if (!layer.isVisible) return;

    canvas.save();

    final center = Offset(
      layer.position.dx + layer.size.width / 2,
      layer.position.dy + layer.size.height / 2,
    );

    canvas.translate(center.dx, center.dy);
    canvas.rotate(layer.rotation * (3.141592653589793 / 180));
    canvas.translate(-center.dx, -center.dy);

    final rect = Rect.fromLTWH(
      layer.position.dx,
      layer.position.dy,
      layer.size.width,
      layer.size.height,
    );

    final paint = Paint()..color = Color.fromRGBO(255, 255, 255, layer.opacity);

    switch (layer) {
      case ImageLayer():
        _renderImage(layer, canvas, rect, paint);
      case TextLayer():
        _renderText(layer, canvas, rect);
      case ShapeLayer():
        _renderShape(layer, canvas, rect);
      case StickerLayer():
        _renderSticker(layer, canvas, rect, paint);
      case PaintLayer():
        _renderPaint(layer, canvas);
    }

    canvas.restore();
  }

  static void _renderImage(
      ImageLayer layer,
      Canvas canvas,
      Rect rect,
      Paint paint,
      ) {
    final cached = _imageCache[layer.resolvedSource];
    if (cached == null) {
      _drawImagePlaceholder(canvas, rect);
      return;
    }

    final effectPaint = _buildEffectPaint(layer.effects, layer.opacity);

    if (layer.effects.blurRadius > 0) {
      effectPaint.imageFilter = ui.ImageFilter.blur(
        sigmaX: layer.effects.blurRadius,
        sigmaY: layer.effects.blurRadius,
      );
    }

    final srcRect = layer.cropRect != null
        ? Rect.fromLTRB(
      layer.cropRect!.left * cached.width,
      layer.cropRect!.top * cached.height,
      layer.cropRect!.right * cached.width,
      layer.cropRect!.bottom * cached.height,
    )
        : Rect.fromLTWH(0, 0, cached.width.toDouble(), cached.height.toDouble());

    canvas.drawImageRect(cached, srcRect, rect, effectPaint);

    if (layer.effects.vignette > 0) {
      _renderVignette(canvas, rect, layer.effects.vignette);
    }
  }

  static void _renderText(TextLayer layer, Canvas canvas, Rect rect) {
    final align = switch (layer.alignment) {
      TextAlignment.left   => ui.TextAlign.left,
      TextAlignment.center => ui.TextAlign.center,
      TextAlignment.right  => ui.TextAlign.right,
    };

    final weight = switch (layer.fontWeight) {
      FontWeight.thin      => ui.FontWeight.w100,
      FontWeight.light     => ui.FontWeight.w300,
      FontWeight.regular   => ui.FontWeight.w400,
      FontWeight.medium    => ui.FontWeight.w500,
      FontWeight.semiBold  => ui.FontWeight.w600,
      FontWeight.bold      => ui.FontWeight.w700,
      FontWeight.extraBold => ui.FontWeight.w800,
    };

    final painter = TextPainter(
      text: TextSpan(
        text: layer.text,
        style: TextStyle(
          fontFamily: layer.fontFamily,
          fontSize: layer.fontSize,
          fontWeight: weight,
          color: layer.color.withOpacity(layer.opacity),
        ),
      ),
      textAlign: align,
      textDirection: ui.TextDirection.ltr,
    );

    painter.layout(maxWidth: rect.width);
    final yOffset = (rect.height - painter.height) / 2;
    painter.paint(canvas, Offset(rect.left, rect.top + yOffset.clamp(0, rect.height)));
  }

  static void _renderShape(ShapeLayer layer, Canvas canvas, Rect rect) {
    final fillPaint = Paint()
      ..color = layer.fillColor.withOpacity(layer.opacity)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = layer.strokeColor.withOpacity(layer.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = layer.strokeWidth;

    switch (layer.shapeType) {
      case ShapeType.rectangle:
        final rRect = layer.cornerRadius > 0
            ? RRect.fromRectAndRadius(rect, Radius.circular(layer.cornerRadius))
            : RRect.fromRectAndRadius(rect, Radius.zero);
        canvas.drawRRect(rRect, fillPaint);
        if (layer.strokeWidth > 0) canvas.drawRRect(rRect, strokePaint);

      case ShapeType.circle:
        canvas.drawOval(rect, fillPaint);
        if (layer.strokeWidth > 0) canvas.drawOval(rect, strokePaint);

      case ShapeType.triangle:
        final path = Path()
          ..moveTo(rect.left + rect.width / 2, rect.top)
          ..lineTo(rect.right, rect.bottom)
          ..lineTo(rect.left, rect.bottom)
          ..close();
        canvas.drawPath(path, fillPaint);
        if (layer.strokeWidth > 0) canvas.drawPath(path, strokePaint);

      case ShapeType.line:
        canvas.drawLine(
          Offset(rect.left, rect.center.dy),
          Offset(rect.right, rect.center.dy),
          strokePaint..strokeWidth = layer.strokeWidth.clamp(1, 40),
        );

      case ShapeType.polygon:
        canvas.drawOval(rect, fillPaint);
        if (layer.strokeWidth > 0) canvas.drawOval(rect, strokePaint);
    }
  }

  static void _renderSticker(
      StickerLayer layer,
      Canvas canvas,
      Rect rect,
      Paint paint,
      ) {
    final cached = _imageCache[layer.stickerUrl];
    if (cached == null) {
      _drawImagePlaceholder(canvas, rect);
      return;
    }
    paint.filterQuality = FilterQuality.high;
    final src = Rect.fromLTWH(0, 0, cached.width.toDouble(), cached.height.toDouble());
    canvas.drawImageRect(cached, src, rect, paint);
  }

  static void _renderPaint(PaintLayer layer, Canvas canvas) {
    for (final stroke in layer.strokes) {
      if (stroke.points.isEmpty) continue;
      final paint = Paint()
        ..color = stroke.color.withOpacity(layer.opacity)
        ..strokeWidth = stroke.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      if (stroke.brushType == BrushType.eraser) {
        paint.blendMode = BlendMode.clear;
      }

      final path = Path()..moveTo(stroke.points.first.dx, stroke.points.first.dy);
      for (int i = 1; i < stroke.points.length; i++) {
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  static void _renderVignette(Canvas canvas, Rect rect, double intensity) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          Colors.black.withOpacity(intensity * 0.85),
        ],
        stops: const [0.5, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  static Paint _buildEffectPaint(EffectConfig effects, double opacity) {
    if (effects.isIdentity) {
      return Paint()..filterQuality = FilterQuality.high;
    }

    final b = effects.brightness;
    final c = effects.contrast;
    final s = effects.saturation;

    // Contrast scale
    final cs = c + 1.0;
    final ct = (1.0 - cs) * 0.5 * 255;

    // Saturation matrix
    final sr = (1 - s) * 0.2126;
    final sg = (1 - s) * 0.7152;
    final sb = (1 - s) * 0.0722;

    final matrix = <double>[
      cs * (sr + s), cs * sg,      cs * sb,      0, ct + b * 255,
      cs * sr,       cs * (sg + s), cs * sb,      0, ct + b * 255,
      cs * sr,       cs * sg,      cs * (sb + s), 0, ct + b * 255,
      0,             0,             0,             1, 0,
    ];

    return Paint()
      ..filterQuality = FilterQuality.high
      ..colorFilter = ui.ColorFilter.matrix(matrix);
  }

  static void _drawImagePlaceholder(Canvas canvas, Rect rect) {
    canvas.drawRect(
      rect,
      Paint()..color = const Color(0x33888888),
    );
    canvas.drawLine(rect.topLeft, rect.bottomRight, Paint()..color = const Color(0x55888888));
    canvas.drawLine(rect.topRight, rect.bottomLeft, Paint()..color = const Color(0x55888888));
  }

  // Called by CanvasView when a network/asset image finishes loading
  static void cacheImage(String key, ui.Image image) {
    _imageCache[key] = image;
  }

  static void evictImage(String key) {
    _imageCache.remove(key);
  }

  static void clearCache() {
    _imageCache.clear();
  }
}
