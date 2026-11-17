import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CacheManager {
  static const String _folderName = 'canvas_studio_cache';

  static Future<Directory> get cacheDir async {
    if (Platform.isAndroid) {
      final dir = Directory('/storage/emulated/0/Android/data/cache/$_folderName');
      await dir.create(recursive: true);
      return dir;
    }
    final temp = await getTemporaryDirectory();
    return Directory('${temp.path}/$_folderName');
  }

  static Future<void> clearCache() async {
    final dir = await cacheDir;
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  static Future<String> writeCache(String key, List<int> bytes) async {
    final dir = await cacheDir;
    final file = File('${dir.path}/$key');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  static Future<List<int>?> readCache(String key) async {
    final dir = await cacheDir;
    final file = File('${dir.path}/$key');
    if (await file.exists()) {
      return file.readAsBytes();
    }
    return null;
  }
}
