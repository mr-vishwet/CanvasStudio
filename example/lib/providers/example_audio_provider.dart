import 'package:canvas_studio/canvas_studio.dart';
import 'dart:async';

class ExampleAudioProvider implements AudioProvider {
  final List<AudioTrack> _tracks;
  final List<String> _categories;

  ExampleAudioProvider()
      : _tracks = _loadTracks(),
        _categories = _loadCategories();

  static List<AudioTrack> _loadTracks() {
    return [
      const AudioTrack(
        id: 'audio_festival_01',
        title: 'Diwali Beat',
        artist: 'DJ India',
        url: 'https://cdn.example.com/diwali_beat.mp3',
        previewUrl: 'https://cdn.example.com/diwali_beat_preview.mp3',
        durationMs: 180000,
        category: 'festival',
        festival: 'diwali',
        isPremium: false,
      ),
      const AudioTrack(
        id: 'audio_festival_02',
        title: 'Bollywood Dance',
        artist: 'A.R. Rahman',
        url: 'https://cdn.example.com/bollywood_dance.mp3',
        previewUrl: 'https://cdn.example.com/bollywood_dance_preview.mp3',
        durationMs: 240000,
        category: 'bollywood',
        festival: 'diwali',
        isPremium: false,
      ),
      const AudioTrack(
        id: 'audio_business_01',
        title: 'Corporate Upbeat',
        artist: 'Studio Music',
        url: 'https://cdn.example.com/corporate.mp3',
        previewUrl: 'https://cdn.example.com/corporate_preview.mp3',
        durationMs: 120000,
        category: 'business',
        festival: null,
        isPremium: true,
      ),
      const AudioTrack(
        id: 'audio_festival_03',
        title: 'Folk Celebration',
        artist: 'Folk Artists',
        url: 'https://cdn.example.com/folk.mp3',
        previewUrl: 'https://cdn.example.com/folk_preview.mp3',
        durationMs: 200000,
        category: 'festival',
        festival: 'holi',
        isPremium: false,
      ),
    ];
  }

  static List<String> _loadCategories() {
    return ['festival', 'bollywood', 'business', 'devotional', 'romantic'];
  }

  @override
  Future<List<AudioTrack>> fetchTracks({String? festival, int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    var filtered = _tracks.where((t) {
      if (festival != null && t.festival != festival) return false;
      return true;
    }).toList();

    final start = (page - 1) * 10;
    final end = start + 10;
    if (start >= filtered.length) return [];
    return filtered.sublist(start, min(end, filtered.length));
  }

  @override
  Future<List<String>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _categories;
  }

  @override
  Future<List<AudioTrack>> fetchUserUploads() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }

  @override
  Future<AudioTrack> uploadAudio(String localFilePath) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return AudioTrack(
      id: 'user_upload_${DateTime.now().millisecondsSinceEpoch}',
      title: 'My Upload',
      artist: 'User',
      url: localFilePath,
      durationMs: 0,
      isPremium: false,
    );
  }

  @override
  bool canAccessTrack(AudioTrack track) => !track.isPremium;
}

int min(int a, int b) => a < b ? a : b;
