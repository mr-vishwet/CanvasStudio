class AudioConfig {
  final String trackId;
  final String trackUrl;
  final String previewUrl;
  final String trackName;
  final Duration duration;
  final double startOffset;    // seconds into track
  final double fadeInSeconds;
  final double fadeOutSeconds;
  final String? festival;

  const AudioConfig({
    required this.trackId,
    required this.trackUrl,
    required this.previewUrl,
    required this.trackName,
    required this.duration,
    this.startOffset = 0.0,
    this.fadeInSeconds = 0.5,
    this.fadeOutSeconds = 1.0,
    this.festival,
  });

  AudioConfig copyWith({
    String? trackUrl,
    String? previewUrl,
    String? trackName,
    Duration? duration,
    double? startOffset,
    double? fadeInSeconds,
    double? fadeOutSeconds,
    String? festival,
  }) =>
      AudioConfig(
        trackId: trackId,
        trackUrl: trackUrl ?? this.trackUrl,
        previewUrl: previewUrl ?? this.previewUrl,
        trackName: trackName ?? this.trackName,
        duration: duration ?? this.duration,
        startOffset: startOffset ?? this.startOffset,
        fadeInSeconds: fadeInSeconds ?? this.fadeInSeconds,
        fadeOutSeconds: fadeOutSeconds ?? this.fadeOutSeconds,
        festival: festival ?? this.festival,
      );

  Map<String, dynamic> toJson() => {
    'track_id': trackId,
    'track_url': trackUrl,
    'preview_url': previewUrl,
    'track_name': trackName,
    'duration_ms': duration.inMilliseconds,
    'start_offset': startOffset,
    'fade_in_seconds': fadeInSeconds,
    'fade_out_seconds': fadeOutSeconds,
    'festival': festival,
  };

  factory AudioConfig.fromJson(Map<String, dynamic> json) => AudioConfig(
    trackId: json['track_id'] as String,
    trackUrl: json['track_url'] as String,
    previewUrl: json['preview_url'] as String,
    trackName: json['track_name'] as String,
    duration: Duration(milliseconds: json['duration_ms'] as int),
    startOffset: (json['start_offset'] as num?)?.toDouble() ?? 0.0,
    fadeInSeconds: (json['fade_in_seconds'] as num?)?.toDouble() ?? 0.5,
    fadeOutSeconds: (json['fade_out_seconds'] as num?)?.toDouble() ?? 1.0,
    festival: json['festival'] as String?,
  );
}
