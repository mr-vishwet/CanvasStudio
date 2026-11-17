import 'package:test/test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('FontLoader', () {
    test('creates instance', () {
      final loader = FontLoader();
      expect(loader, isNotNull);
    });
  });
}
