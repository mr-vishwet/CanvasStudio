import 'layer.dart';
import 'text_layer.dart';
import 'image_layer.dart';
import 'shape_layer.dart';
import 'sticker_layer.dart';
import 'paint_layer.dart';

export 'layer.dart';
export 'text_layer.dart';
export 'image_layer.dart';
export 'shape_layer.dart';
export 'sticker_layer.dart';
export 'paint_layer.dart';

Layer layerFromJson(Map<String, dynamic> json) {
  final type = LayerType.values.byName(json['type'] as String);
  return switch (type) {
    LayerType.text    => TextLayer.fromJson(json),
    LayerType.image   => ImageLayer.fromJson(json),
    LayerType.shape   => ShapeLayer.fromJson(json),
    LayerType.sticker => StickerLayer.fromJson(json),
    LayerType.paint   => PaintLayer.fromJson(json),
  };
}
