import 'package:flutter/painting.dart';

class CanvasFontConfig {
  final List<String> googleFontFamilies;
  final Map<String, String> assetFontFamilies; // familyName -> asset path
  final Map<String, String> networkFontFamilies; // familyName -> font URL
  final bool loadIndicScripts;
  final List<String> indicScripts;

  const CanvasFontConfig({
    this.googleFontFamilies = const [],
    this.assetFontFamilies = const {},
    this.networkFontFamilies = const {},
    this.loadIndicScripts = true,
    this.indicScripts = const ['devanagari', 'bengali', 'tamil', 'telugu', 'gujarati'],
  });

  List<String> get allFamilies =>
      [...googleFontFamilies, ...assetFontFamilies.keys, ...networkFontFamilies.keys];

  FontStyle? resolveStyle(String family) {
    // Resolves to a TextStyle-friendly font family; host app registers fonts in pubspec
    return null;
  }
}
