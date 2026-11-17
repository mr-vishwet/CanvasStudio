import 'package:flutter/foundation.dart';

class AudioLibraryController extends ChangeNotifier {
  List<AudioTrack> _tracks = [];
  bool _isLoading = false;
  AudioTrack? _selected;

  List<AudioTrack> get tracks => _tracks;
  bool get isLoading => _isLoading;
  AudioTrack? get selected => _selected;

  void setTracks(List<AudioTrack> tracks) {
    _tracks = tracks;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void selectTrack(AudioTrack? track) {
    _selected = track;
    notifyListeners();
  }
}

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
}
