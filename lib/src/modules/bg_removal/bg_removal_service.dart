import 'dart:typed_data';
import '../../models/layer/image_layer.dart';
import 'bg_removal_config.dart';

class BgRemovalService {
  final BgRemovalConfig config;

  BgRemovalService({this.config = const BgRemovalConfig()});

  Future<Uint8List?> removeBackground(ImageLayer layer) async {
    switch (config.mode) {
      case BgRemovalMode.onDevice:
        return _removeOnDevice(layer);
      case BgRemovalMode.backendApi:
        return _removeViaBackend(layer);
      case BgRemovalMode.tiered:
        final result = await _removeOnDevice(layer);
        if (result != null) return result;
        return _removeViaBackend(layer);
    }
  }

  Future<Uint8List?> _removeOnDevice(ImageLayer layer) async {
    return null;
  }

  Future<Uint8List?> _removeViaBackend(ImageLayer layer) async {
    return null;
  }
}
