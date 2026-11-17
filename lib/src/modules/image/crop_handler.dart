import 'package:flutter/painting.dart';

class CropHandler {
  static Rect clampToImage(Rect crop, Size imageSize) => Rect.fromLTRB(
    crop.left.clamp(0.0, imageSize.width),
    crop.top.clamp(0.0, imageSize.height),
    crop.right.clamp(0.0, imageSize.width),
    crop.bottom.clamp(0.0, imageSize.height),
  );

  static Rect normalize(Rect crop, Size imageSize) => Rect.fromLTRB(
    crop.left / imageSize.width,
    crop.top / imageSize.height,
    crop.right / imageSize.width,
    crop.bottom / imageSize.height,
  );

  static Rect denormalize(Rect norm, Size imageSize) => Rect.fromLTRB(
    norm.left * imageSize.width,
    norm.top * imageSize.height,
    norm.right * imageSize.width,
    norm.bottom * imageSize.height,
  );
}
