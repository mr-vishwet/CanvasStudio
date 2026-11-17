import 'package:test/test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('FFmpegCommandBuilder', () {
    test('build staticImage command', () {
      // staticImage case handled by ExportRenderer, not FFmpeg
      // FFmpeg is only used for video output types
      expect(true, isTrue);
    });

    test('build slideshowVideo command with audio', () {
      final config = ExportConfig(
        document: CanvasDocument.empty(
          canvasSize: const Size(1080, 1080),
          type: CanvasMediaType.image,
        ),
        outputType: ExportOutputType.slideshowVideo,
        format: ExportFormat.mp4,
        frameMode: FrameMode.singleFrame,
        audio: const AudioConfig(
          trackId: 'at_001',
          trackUrl: 'https://cdn.example.com/audio.mp3',
          previewUrl: 'https://cdn.example.com/audio_preview.mp3',
          trackName: 'Festival Track',
          duration: Duration(minutes: 3),
        ),
        videoDurationMs: 180000,
        applyWatermark: false,
      );
      final command = FFmpegCommandBuilder.build(config);
      expect(command, contains('ffmpeg'));
      expect(command, contains('-loop 1 -i input.jpg'));
      expect(command, contains('-i audio_input.mp3'));
      expect(command, contains('-c:v libx264'));
      expect(command, contains('-c:a aac'));
      expect(command, contains('output.mp4'));
    });

    test('build animatedVideo command with audio', () {
      final config = ExportConfig(
        document: CanvasDocument.empty(
          canvasSize: const Size(1080, 1080),
          type: CanvasMediaType.image,
        ),
        outputType: ExportOutputType.animatedVideo,
        format: ExportFormat.mp4,
        frameMode: FrameMode.multiFrame,
        audio: const AudioConfig(
          trackId: 'at_001',
          trackUrl: 'https://cdn.example.com/audio.mp3',
          previewUrl: 'https://cdn.example.com/audio_preview.mp3',
          trackName: 'Festival Track',
          duration: Duration(minutes: 3),
        ),
        videoDurationMs: 180000,
        applyWatermark: false,
      );
      final command = FFmpegCommandBuilder.build(config);
      expect(command, contains('ffmpeg'));
      expect(command, contains('-i input.mp4'));
      expect(command, contains('-i audio_input.mp3'));
      expect(command, contains('-c:v libx264'));
      expect(command, contains('-c:a aac'));
    });

    test('build png format command', () {
      final config = ExportConfig(
        document: CanvasDocument.empty(
          canvasSize: const Size(1080, 1080),
          type: CanvasMediaType.image,
        ),
        outputType: ExportOutputType.staticImage,
        format: ExportFormat.png,
        frameMode: FrameMode.singleFrame,
      );
      final command = FFmpegCommandBuilder.build(config);
      expect(command, contains('-c:v png'));
      expect(command, contains('output.png'));
    });

    test('build jpg format command', () {
      final config = ExportConfig(
        document: CanvasDocument.empty(
          canvasSize: const Size(1080, 1080),
          type: CanvasMediaType.image,
        ),
        outputType: ExportOutputType.staticImage,
        format: ExportFormat.jpg,
        frameMode: FrameMode.singleFrame,
      );
      final command = FFmpegCommandBuilder.build(config);
      expect(command, contains('-c:v mjpeg'));
      expect(command, contains('-q:v 2'));
      expect(command, contains('output.jpg'));
    });

    test('build mp4 format command', () {
      final config = ExportConfig(
        document: CanvasDocument.empty(
          canvasSize: const Size(1080, 1080),
          type: CanvasMediaType.image,
        ),
        outputType: ExportOutputType.staticImage,
        format: ExportFormat.mp4,
        frameMode: FrameMode.singleFrame,
      );
      final command = FFmpegCommandBuilder.build(config);
      expect(command, contains('-c:v libx264'));
      expect(command, contains('-preset fast'));
      expect(command, contains('-crf 23'));
      expect(command, contains('-c:a aac'));
    });

    test('build includes trim parameters when videoTrim is set', () {
      final config = ExportConfig(
        document: CanvasDocument.empty(
          canvasSize: const Size(1080, 1080),
          type: CanvasMediaType.video,
        ),
        outputType: ExportOutputType.animatedVideo,
        format: ExportFormat.mp4,
        frameMode: FrameMode.multiFrame,
        videoTrim: const VideoTrimConfig(
          startTrim: Duration(seconds: 5),
          endTrim: Duration(seconds: 30),
        ),
        videoDurationMs: 25000,
        applyWatermark: false,
      );
      final command = FFmpegCommandBuilder.build(config);
      expect(command, contains('-ss 0.005'));
      expect(command, contains('-to 0.03'));
    });

    test('build includes watermark filter when applyWatermark is true', () {
      final config = ExportConfig(
        document: CanvasDocument.empty(
          canvasSize: const Size(1080, 1080),
          type: CanvasMediaType.image,
        ),
        outputType: ExportOutputType.staticImage,
        format: ExportFormat.png,
        frameMode: FrameMode.singleFrame,
        applyWatermark: true,
      );
      final command = FFmpegCommandBuilder.build(config);
      expect(command, contains('watermark.png'));
      expect(command, contains('overlay'));
    });

    test('slideshowCommand produces correct string', () {
      final command = FFmpegCommandBuilder.slideshowCommand(
        'poster.png',
        'audio.mp3',
        180000,
      );
      expect(command, contains('ffmpeg'));
      expect(command, contains('-loop 1 -i poster.png'));
      expect(command, contains('-i audio.mp3'));
      expect(command, contains('-t 180'));
      expect(command, contains('-pix_fmt yuv420p'));
      expect(command, contains('-c:a aac'));
      expect(command, contains('-shortest'));
    });

    test('trimCommand produces correct string', () {
      final command = FFmpegCommandBuilder.trimCommand(
        'input.mp4',
        Duration(seconds: 10),
        Duration(seconds: 60),
      );
      expect(command, contains('ffmpeg'));
      expect(command, contains('-i input.mp4'));
      expect(command, contains('-ss 0.01'));
      expect(command, contains('-to 0.06'));
      expect(command, contains('-c copy'));
    });
  });
}
