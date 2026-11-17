import 'package:flutter/material.dart';

class VideoToolbar extends StatelessWidget {
  final VoidCallback onTrim;
  final VoidCallback onRotate;
  final VoidCallback onCoverSelect;
  final VoidCallback onCrop;

  const VideoToolbar({
    super.key,
    required this.onTrim,
    required this.onRotate,
    required this.onCoverSelect,
    required this.onCrop,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(icon: const Icon(Icons.crop), onPressed: onTrim, tooltip: 'Trim'),
        IconButton(icon: const Icon(Icons.rotate_90_degrees_cw), onPressed: onRotate, tooltip: 'Rotate'),
        IconButton(icon: const Icon(Icons.face), onPressed: onCoverSelect, tooltip: 'Select Cover'),
        IconButton(icon: const Icon(Icons.crop_rotate), onPressed: onCrop, tooltip: 'Crop'),
      ],
    );
  }
}
