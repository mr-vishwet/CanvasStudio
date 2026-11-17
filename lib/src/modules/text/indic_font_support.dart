class IndicFontSupport {
  static const Map<String, String> indicScriptFonts = {
    'devanagari': 'NotoSansDevanagari',
    'bengali': 'NotoSansBengali',
    'tamil': 'NotoSansTamil',
    'telugu': 'NotoSansTelugu',
    'gujarati': 'NotoSansGujarati',
  };

  static bool containsIndicScript(String text) {
    final indicRanges = [
      0x0900, 0x097F,
      0x0980, 0x09FF,
      0x0B80, 0x0BFF,
      0x0C00, 0x0C7F,
      0x0A80, 0x0AFF,
    ];
    for (final char in text.runes) {
      for (var i = 0; i < indicRanges.length; i += 2) {
        if (char >= indicRanges[i] && char <= indicRanges[i + 1]) {
          return true;
        }
      }
    }
    return false;
  }

  static String? fontForScript(String script) => indicScriptFonts[script.toLowerCase()];
}
