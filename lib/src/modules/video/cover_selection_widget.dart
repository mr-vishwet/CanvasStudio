import 'package:flutter/material.dart';

class CoverSelectionWidget extends StatelessWidget {
  final Duration coverTime;
  final Duration totalDuration;
  final ValueChanged<Duration> onCoverSelected;

  const CoverSelectionWidget({
    super.key,
    required this.coverTime,
    required this.totalDuration,
    required this.onCoverSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Select Cover Frame'),
        Slider(
          value: coverTime.inMilliseconds.toDouble(),
          min: 0,
          max: totalDuration.inMilliseconds.toDouble(),
          onChanged: (v) => onCoverSelected(Duration(milliseconds: v.toInt())),
        ),
      ],
    );
  }
}
