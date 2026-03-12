import '../canvas_document.dart';
import '../audio_config.dart';
import 'video_trim_config.dart';

enum ExportFormat { png, jpg, mp4 }
enum ExportOutputType { staticImage, slideshowVideo, animatedVideo }
enum FrameMode { singleFrame, multiFrame }

class ExportConfig {
  final String? templateId;
  final CanvasDocument document;
  final ExportOutputType outputType;
  final ExportFormat format;
  final AudioConfig? audio;
  final VideoTrimConfig? videoTrim;
  final int videoDurationMs;
  final FrameMode frameMode;
  final bool applyWatermark;

  const ExportConfig({
    required this.document,
    required this.outputType,
    required this.format,
    required this.frameMode,
    this.templateId,
    this.audio,
    this.videoTrim,
    this.videoDurationMs = 0,
    this.applyWatermark = false,
  });

  // Auto-resolve output type from document state
  factory ExportConfig.resolve({
    required CanvasDocument document,
    required ExportFormat format,
    bool applyWatermark = false,
  }) {
    final ExportOutputType outputType;
    final FrameMode frameMode;

    if (format != ExportFormat.mp4 || document.audio == null) {
      // Pure image export
      outputType = ExportOutputType.staticImage;
      frameMode = FrameMode.singleFrame;
    } else if (document.hasAnimationLayers) {
      // Image/video with animations + audio → full animated video
      outputType = ExportOutputType.animatedVideo;
      frameMode = FrameMode.multiFrame;
    } else {
      // Image + audio, no animations → freeze-frame slideshow
      outputType = ExportOutputType.slideshowVideo;
      frameMode = FrameMode.singleFrame;
    }

    return ExportConfig(
      templateId: document.templateId,
      document: document,
      outputType: outputType,
      format: format,
      audio: document.audio,
      videoTrim: document.videoTrim,
      videoDurationMs: document.audio?.duration.inMilliseconds ?? 0,
      frameMode: frameMode,
      applyWatermark: applyWatermark,
    );
  }

  Map<String, dynamic> toJson() => {
    'template_id': templateId,
    'document': document.toJson(),
    'output_type': outputType.name,
    'format': format.name,
    'audio': audio?.toJson(),
    'video_trim': videoTrim?.toJson(),
    'video_duration_ms': videoDurationMs,
    'frame_mode': frameMode.name,
    'apply_watermark': applyWatermark,
  };
}
