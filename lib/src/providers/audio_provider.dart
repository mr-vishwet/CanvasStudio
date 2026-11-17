import '../modules/audio/audio_track_model.dart';

abstract class AudioProvider {
  Future<List<AudioTrack>> fetchTracks({String? festival, int page = 1});
  Future<List<String>> fetchCategories();
  Future<List<AudioTrack>> fetchUserUploads();
  Future<AudioTrack> uploadAudio(String localFilePath);
  bool canAccessTrack(AudioTrack track);
}
