import 'package:flutter/material.dart';
import '../../models/export/video_trim_config.dart';

class VideoTrimWidget extends StatelessWidget {
  final VideoTrimConfig config;
  final ValueChanged<VideoTrimConfig> onChanged;

  const VideoTrimWidget({
    super.key,
    required this.config,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Video Trim'),
        Slider(
          value: config.startTrim.inMilliseconds.toDouble(),
          min: 0,
          max: config.endTrim.inMilliseconds.toDouble(),
          onChanged: (v) => onChanged(
            config.copyWith(startTrim: Duration(milliseconds: v.toInt())),
          ),
        ),
        Slider(
          value: config.endTrim.inMilliseconds.toDouble(),
          min: config.startTrim.inMilliseconds.toDouble(),
          max: 300000,
          onChanged: (v) => onChanged(
            config.copyWith(endTrim: Duration(milliseconds: v.toInt())),
          ),
        ),
      ],
    );
  }
}
