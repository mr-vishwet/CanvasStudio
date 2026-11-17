import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../models/export/export_config.dart';
import '../../rendering/export_renderer.dart';

class ExportHandler {
  static const String _folderName = 'CanvasStudio';

  static Future<ExportHandlerResult> export(ExportConfig config) async {
    switch (config.outputType) {
      case ExportOutputType.staticImage:
        return _exportImage(config);
      case ExportOutputType.slideshowVideo:
      case ExportOutputType.animatedVideo:
        return _exportVideo(config);
    }
  }

  // ── Image ────────────────────────────────────────────────

  static Future<ExportHandlerResult> _exportImage(ExportConfig config) async {
    final result = await ExportRenderer.renderToBytes(
      config.document,
      config.format,
    );
    final file = await _writeToDownloads(result.bytes, result.suggestedFileName);
    return ExportHandlerResult(
      filePath: file.path,
      format: config.format,
      width: result.width,
      height: result.height,
    );
  }

  // ── Video (Phase 4 placeholder) ───────────────────────────

  static Future<ExportHandlerResult> _exportVideo(ExportConfig config) async {
    final result = await ExportRenderer.renderToBytes(
      config.document,
      ExportFormat.png,
    );
    final file = await _writeToDownloads(result.bytes, result.suggestedFileName);
    return ExportHandlerResult(
      filePath: file.path,
      format: ExportFormat.png,
      width: result.width,
      height: result.height,
      isVideoPlaceholder: true,
    );
  }

  // ── File I/O ──────────────────────────────────────────────

  /// Writes to:
  ///   Android → /storage/emulated/0/Download/CanvasStudio/<file>
  ///   iOS     → <app Documents>/CanvasStudio/<file>   (accessible via Files app)
  ///   Others  → <temp dir>/CanvasStudio/<file>
  static Future<File> _writeToDownloads(
      List<int> bytes,
      String fileName,
      ) async {
    final dir = await _resolveOutputDirectory();
    await dir.create(recursive: true);
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static Future<Directory> _resolveOutputDirectory() async {
    if (Platform.isAndroid) {
      // Public Downloads — visible in Files app without any permission on Android 10+
      const downloadsPath = '/storage/emulated/0/Download';
      return Directory('$downloadsPath/$_folderName');
    }

    if (Platform.isIOS) {
      // iOS sandboxed — accessible via Files app → On My iPhone → <AppName>
      final docs = await getApplicationDocumentsDirectory();
      return Directory('${docs.path}/$_folderName');
    }

    // Fallback (desktop, tests)
    final temp = await getTemporaryDirectory();
    return Directory('${temp.path}/$_folderName');
  }

  /// Returns human-readable path shown in the success snackbar
  static String friendlyPath(String filePath) {
    if (Platform.isAndroid) {
      return filePath.replaceFirst('/storage/emulated/0/', 'Internal Storage/');
    }
    return filePath;
  }
}

class ExportHandlerResult {
  final String filePath;
  final ExportFormat format;
  final int width;
  final int height;
  final bool isVideoPlaceholder;

  const ExportHandlerResult({
    required this.filePath,
    required this.format,
    required this.width,
    required this.height,
    this.isVideoPlaceholder = false,
  });

  File get file => File(filePath);
  String get dimensionsLabel => '${width}x$height';
  String get friendlyPath => ExportHandler.friendlyPath(filePath);
}
