import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class FontLoader {
  static Future<void> loadGoogleFont(String family) async {
    GoogleFonts.getFont(family);
  }

  static Future<void> loadAssetFont(String family, String path) async {
    await rootBundle.load(path);
  }

  static Future<void> loadNetworkFont(String family, String url) async {
    // Host app registers network fonts via CanvasFontConfig
    // This is a placeholder for future font downloading
  }
}
