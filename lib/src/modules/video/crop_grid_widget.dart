import 'package:flutter/material.dart';

class CropGridWidget extends StatelessWidget {
  final Offset minCrop;
  final Offset maxCrop;
  final ValueChanged<Offset> onMinCropChanged;
  final ValueChanged<Offset> onMaxCropChanged;

  const CropGridWidget({
    super.key,
    required this.minCrop,
    required this.maxCrop,
    required this.onMinCropChanged,
    required this.onMaxCropChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Crop Grid'),
        Slider(
          value: minCrop.dx,
          min: 0.0,
          max: 1.0,
          onChanged: (v) => onMinCropChanged(Offset(v, minCrop.dy)),
        ),
        Slider(
          value: minCrop.dy,
          min: 0.0,
          max: 1.0,
          onChanged: (v) => onMinCropChanged(Offset(minCrop.dx, v)),
        ),
        Slider(
          value: maxCrop.dx,
          min: 0.0,
          max: 1.0,
          onChanged: (v) => onMaxCropChanged(Offset(v, maxCrop.dy)),
        ),
        Slider(
          value: maxCrop.dy,
          min: 0.0,
          max: 1.0,
          onChanged: (v) => onMaxCropChanged(Offset(maxCrop.dx, v)),
        ),
      ],
    );
  }
}
