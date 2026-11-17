import 'package:flutter/painting.dart';

class TextFitUtil {
  /// Calculate the font size needed to fit text within a given width
  static double fitFontSize(
    String text, {
    required double maxWidth,
    required double maxHeight,
    String fontFamily = 'Roboto',
    double maxFontSize = 200.0,
    double minFontSize = 8.0,
  }) {
    var size = maxFontSize;
    while (size > minFontSize) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: TextStyle(fontSize: size, fontFamily: fontFamily)),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: maxWidth);
      if (painter.size.width <= maxWidth && painter.size.height <= maxHeight) {
        return size;
      }
      size -= 1.0;
    }
    return minFontSize;
  }
}
