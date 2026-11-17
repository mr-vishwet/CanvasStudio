import 'package:test/test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('ConnectivityWatcher', () {
    test('creates instance', () {
      final watcher = ConnectivityWatcher();
      expect(watcher, isNotNull);
    });

    test('connectionStatusStream is a stream', () {
      final watcher = ConnectivityWatcher();
      expect(watcher.connectionStatusStream, isA<Stream<bool>>());
    });
  });
}
