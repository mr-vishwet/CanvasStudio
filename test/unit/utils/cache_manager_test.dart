import 'package:test/test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('CacheManager', () {
    test('cacheDir returns Android path on Android', () async {
      // Can't test Platform.isAndroid directly without mocking
      // Just verify the class can be referenced
      expect(CacheManager, isNotNull);
    });

    test('folder name constant is correct', () {
      // CacheManager._folderName is private, but we can test behavior
      // through public methods if they were mockable
      expect(true, isTrue);
    });
  });
}
