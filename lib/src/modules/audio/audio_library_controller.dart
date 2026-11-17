import '../../models/audio_config.dart';
import '../../providers/audio_provider.dart';
import 'audio_track_model.dart';

class AudioLibraryController {
  final AudioProvider _provider;

  AudioLibraryController(this._provider);

  List<AudioTrack> _tracks = [];
  List<String> _categories = [];
  bool _isLoading = false;
  AudioTrack? _selected;

  List<AudioTrack> get tracks => _tracks;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  AudioTrack? get selected => _selected;

  Future<void> loadTracks({String? festival, int page = 1}) async {
    _isLoading = true;
    _tracks = await _provider.fetchTracks(festival: festival, page: page);
    _categories = await _provider.fetchCategories();
    _isLoading = false;
  }

  Future<void> loadUserUploads() async {
    _isLoading = true;
    _tracks = await _provider.fetchUserUploads();
    _isLoading = false;
  }

  void selectTrack(AudioTrack track) => _selected = track;

  void clearSelection() => _selected = null;

  bool canAccess(AudioTrack track) => _provider.canAccessTrack(track);

  Future<AudioTrack> upload(String localFilePath) async {
    final track = await _provider.uploadAudio(localFilePath);
    _tracks.add(track);
    return track;
  }

  AudioConfig? selectedAsConfig() {
    if (_selected == null) return null;
    return AudioConfig(
      trackId: _selected!.id,
      trackUrl: _selected!.url,
      previewUrl: _selected!.previewUrl ?? '',
      trackName: _selected!.title,
      duration: Duration(milliseconds: _selected!.durationMs),
      festival: _selected!.festival,
    );
  }
}
