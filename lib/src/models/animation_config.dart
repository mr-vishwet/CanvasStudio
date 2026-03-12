enum AnimationType {
  fade,
  slideLeft,
  slideRight,
  slideUp,
  slideDown,
  zoom,
  bounce,
  rotate,
}

class AnimationConfig {
  final AnimationType type;
  final double startTimeSeconds;
  final double durationSeconds;

  const AnimationConfig({
    required this.type,
    required this.startTimeSeconds,
    required this.durationSeconds,
  });

  AnimationConfig copyWith({
    AnimationType? type,
    double? startTimeSeconds,
    double? durationSeconds,
  }) =>
      AnimationConfig(
        type: type ?? this.type,
        startTimeSeconds: startTimeSeconds ?? this.startTimeSeconds,
        durationSeconds: durationSeconds ?? this.durationSeconds,
      );

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'start_time_seconds': startTimeSeconds,
    'duration_seconds': durationSeconds,
  };

  factory AnimationConfig.fromJson(Map<String, dynamic> json) =>
      AnimationConfig(
        type: AnimationType.values.byName(json['type'] as String),
        startTimeSeconds: (json['start_time_seconds'] as num).toDouble(),
        durationSeconds: (json['duration_seconds'] as num).toDouble(),
      );
}
