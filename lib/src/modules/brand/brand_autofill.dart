import '../../models/canvas_document.dart';
import '../../models/layer/layers.dart';
import '../../models/brand_profile.dart';

class BrandAutoFill {
  static CanvasDocument apply(CanvasDocument doc, BrandProfile profile) {
    final mapping = <String, String>{
      'business_name': profile.businessName,
      'phone': profile.phone,
      'address': profile.address,
      if (profile.tagline != null) 'tagline': profile.tagline!,
    };

    final updatedLayers = <Layer>[];
    for (final layer in doc.layers) {
      if (layer is TextLayer && mapping.containsKey(layer.placeholderName)) {
        updatedLayers.add(layer.copyWith(text: mapping[layer.placeholderName]));
      } else if (layer is ImageLayer &&
          layer.placeholderName == 'logo' &&
          profile.logoUrl != null) {
        updatedLayers.add(layer.copyWith(imageUrl: profile.logoUrl));
      } else {
        updatedLayers.add(layer);
      }
    }

    return doc.copyWith(layers: updatedLayers);
  }
}
