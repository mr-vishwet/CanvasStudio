import 'package:flutter/painting.dart';

class VideoTrimConfig {
  final Duration startTrim;
  final Duration endTrim;
  final Offset minCrop;   // normalized 0.0–1.0 top-left
  final Offset maxCrop;   // normalized 0.0–1.0 bottom-right
  final int rotation;     // 0 | 90 | 180 | 270

  const VideoTrimConfig({
    required this.startTrim,
    required this.endTrim,
    this.minCrop = Offset.zero,
    this.maxCrop = const Offset(1.0, 1.0),
    this.rotation = 0,
  });

  Duration get trimmedDuration => endTrim - startTrim;

  bool get isCropped => minCrop != Offset.zero || maxCrop != const Offset(1.0, 1.0);

  VideoTrimConfig copyWith({
    Duration? startTrim,
    Duration? endTrim,
    Offset? minCrop,
    Offset? maxCrop,
    int? rotation,
  }) =>
      VideoTrimConfig(
        startTrim: startTrim ?? this.startTrim,
        endTrim: endTrim ?? this.endTrim,
        minCrop: minCrop ?? this.minCrop,
        maxCrop: maxCrop ?? this.maxCrop,
        rotation: rotation ?? this.rotation,
      );

  Map<String, dynamic> toJson() => {
    'start_trim_ms': startTrim.inMilliseconds,
    'end_trim_ms': endTrim.inMilliseconds,
    'min_crop': {'x': minCrop.dx, 'y': minCrop.dy},
    'max_crop': {'x': maxCrop.dx, 'y': maxCrop.dy},
    'rotation': rotation,
  };

  factory VideoTrimConfig.fromJson(Map<String, dynamic> json) => VideoTrimConfig(
    startTrim: Duration(milliseconds: json['start_trim_ms'] as int),
    endTrim: Duration(milliseconds: json['end_trim_ms'] as int),
    minCrop: Offset(
      (json['min_crop']['x'] as num).toDouble(),
      (json['min_crop']['y'] as num).toDouble(),
    ),
    maxCrop: Offset(
      (json['max_crop']['x'] as num).toDouble(),
      (json['max_crop']['y'] as num).toDouble(),
    ),
    rotation: json['rotation'] as int? ?? 0,
  );
}
