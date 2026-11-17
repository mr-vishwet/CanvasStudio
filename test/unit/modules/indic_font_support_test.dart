import 'package:test/test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('IndicFontSupport', () {
    test('containsIndicScript returns true for Devanagari text', () {
      expect(IndicFontSupport.containsIndicScript('नमस्ते'), isTrue);
    });

    test('containsIndicScript returns true for Bengali text', () {
      expect(IndicFontSupport.containsIndicScript('নমস্কার'), isTrue);
    });

    test('containsIndicScript returns true for Tamil text', () {
      expect(IndicFontSupport.containsIndicScript('வணக்கம்'), isTrue);
    });

    test('containsIndicScript returns true for Telugu text', () {
      expect(IndicFontSupport.containsIndicScript('నమస్కారం'), isTrue);
    });

    test('containsIndicScript returns true for Gujarati text', () {
      expect(IndicFontSupport.containsIndicScript('નમસ્તે'), isTrue);
    });

    test('containsIndicScript returns false for Latin text', () {
      expect(IndicFontSupport.containsIndicScript('Hello World'), isFalse);
    });

    test('containsIndicScript returns false for empty string', () {
      expect(IndicFontSupport.containsIndicScript(''), isFalse);
    });

    test('containsIndicScript returns false for mixed Latin with no Indic', () {
      expect(IndicFontSupport.containsIndicScript('12345 !@#$%'), isFalse);
    });

    test('fontForScript returns correct font for devanagari', () {
      expect(IndicFontSupport.fontForScript('devanagari'), 'NotoSansDevanagari');
    });

    test('fontForScript returns correct font for bengali', () {
      expect(IndicFontSupport.fontForScript('bengali'), 'NotoSansBengali');
    });

    test('fontForScript returns correct font for tamil', () {
      expect(IndicFontSupport.fontForScript('tamil'), 'NotoSansTamil');
    });

    test('fontForScript returns correct font for telugu', () {
      expect(IndicFontSupport.fontForScript('telugu'), 'NotoSansTelugu');
    });

    test('fontForScript returns correct font for gujarati', () {
      expect(IndicFontSupport.fontForScript('gujarati'), 'NotoSansGujarati');
    });

    test('fontForScript returns null for unknown script', () {
      expect(IndicFontSupport.fontForScript('unknown'), null);
    });

    test('fontForScript is case-insensitive', () {
      expect(IndicFontSupport.fontForScript('DEVANAGARI'), 'NotoSansDevanagari');
      expect(IndicFontSupport.fontForScript('Devanagari'), 'NotoSansDevanagari');
    });

    test('indicScriptFonts contains all 5 scripts', () {
      expect(IndicFontSupport.indicScriptFonts, hasLength(5));
      expect(IndicFontSupport.indicScriptFonts.containsKey('devanagari'), isTrue);
      expect(IndicFontSupport.indicScriptFonts.containsKey('bengali'), isTrue);
      expect(IndicFontSupport.indicScriptFonts.containsKey('tamil'), isTrue);
      expect(IndicFontSupport.indicScriptFonts.containsKey('telugu'), isTrue);
      expect(IndicFontSupport.indicScriptFonts.containsKey('gujarati'), isTrue);
    });
  });
}
