import 'package:flutter/material.dart';

class ImageToolbar extends StatelessWidget {
  final VoidCallback onReplace;
  final VoidCallback onCrop;
  final VoidCallback onRemoveBg;
  final VoidCallback onEffects;

  const ImageToolbar({
    super.key,
    required this.onReplace,
    required this.onCrop,
    required this.onRemoveBg,
    required this.onEffects,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(icon: const Icon(Icons.sync), onPressed: onReplace, tooltip: 'Replace'),
        IconButton(icon: const Icon(Icons.crop), onPressed: onCrop, tooltip: 'Crop'),
        IconButton(icon: const Icon(Icons.cut), onPressed: onRemoveBg, tooltip: 'Remove Background'),
        IconButton(icon: const Icon(Icons.filter_alt), onPressed: onEffects, tooltip: 'Effects'),
      ],
    );
  }
}
