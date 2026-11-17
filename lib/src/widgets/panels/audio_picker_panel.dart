import 'package:flutter/material.dart';
import '../../modules/audio/audio_track_model.dart';

class AudioPickerPanel extends StatelessWidget {
  final List<AudioTrack> tracks;
  final AudioTrack? selected;
  final ValueChanged<AudioTrack> onTrackSelected;

  const AudioPickerPanel({
    super.key,
    required this.tracks,
    this.selected,
    required this.onTrackSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Audio Library'),
        Expanded(
          child: ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              final isSelected = selected?.id == track.id;
              return ListTile(
                leading: const Icon(Icons.audiotrack),
                title: Text(track.title),
                subtitle: Text(track.artist),
                selected: isSelected,
                onTap: () => onTrackSelected(track),
              );
            },
          ),
        ),
      ],
    );
  }
}
