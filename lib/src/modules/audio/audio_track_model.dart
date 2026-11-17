class AudioTrack {
  final String id;
  final String title;
  final String artist;
  final String url;
  final String? previewUrl;
  final int durationMs;
  final String? category;
  final String? festival;
  final bool isPremium;

  const AudioTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.url,
    this.previewUrl,
    required this.durationMs,
    this.category,
    this.festival,
    this.isPremium = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'artist': artist,
    'url': url,
    'preview_url': previewUrl,
    'duration_ms': durationMs,
    'category': category,
    'festival': festival,
    'is_premium': isPremium,
  };

  factory AudioTrack.fromJson(Map<String, dynamic> json) => AudioTrack(
    id: json['id'] as String,
    title: json['title'] as String,
    artist: json['artist'] as String,
    url: json['url'] as String,
    previewUrl: json['preview_url'] as String?,
    durationMs: json['duration_ms'] as int? ?? 0,
    category: json['category'] as String?,
    festival: json['festival'] as String?,
    isPremium: json['is_premium'] as bool? ?? false,
  );
}
