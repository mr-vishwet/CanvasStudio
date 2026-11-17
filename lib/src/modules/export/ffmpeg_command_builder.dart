import '../../models/export/export_config.dart';

class FFmpegCommandBuilder {
  static String build(ExportConfig config) {
    final buffer = StringBuffer();
    buffer.write('ffmpeg');

    if (config.outputType == ExportOutputType.staticImage) {
      buffer.write(' -loop 1 -i input.jpg');
    } else if (config.outputType == ExportOutputType.slideshowVideo) {
      buffer.write(' -loop 1 -i input.jpg');
      if (config.audio != null) {
        buffer.write(' -i audio_input.mp3');
      }
    } else if (config.outputType == ExportOutputType.animatedVideo) {
      buffer.write(' -i input.mp4');
      if (config.audio != null) {
        buffer.write(' -i audio_input.mp3');
      }
    }

    switch (config.format) {
      case ExportFormat.png:
        buffer.write(' -c:v png output.png');
        break;
      case ExportFormat.jpg:
        buffer.write(' -c:v mjpeg -q:v 2 output.jpg');
        break;
      case ExportFormat.mp4:
        buffer.write(' -c:v libx264 -preset fast -crf 23 -c:a aac output.mp4');
        break;
    }

    if (config.videoTrim != null) {
      buffer.write(' -ss ${config.videoTrim!.startTrim.inMilliseconds / 1000}');
      buffer.write(' -to ${config.videoTrim!.endTrim.inMilliseconds / 1000}');
    }

    if (config.applyWatermark) {
      buffer.write(' -vf \"movie=watermark.png [watermark]; [in][watermark] overlay=main_w-overlay_w-10:10 [out]\"');
    }

    return buffer.toString().trim();
  }

  static String slideshowCommand(String imagePath, String audioPath, int durationMs) =>
      'ffmpeg -loop 1 -i $imagePath -i $audioPath -c:v libx264 -t ${durationMs / 1000} -pix_fmt yuv420p -c:a aac -shortest output.mp4';

  static String trimCommand(String inputPath, Duration start, Duration end) =>
      'ffmpeg -i $inputPath -ss ${start.inMilliseconds / 1000} -to ${end.inMilliseconds / 1000} -c copy output.mp4';
}
