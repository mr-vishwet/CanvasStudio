import 'package:flutter/material.dart';

class VideoThumbnailStrip extends StatelessWidget {
  final List<String> thumbnailUrls;
  final int selectedIndex;
  final ValueChanged<int> onThumbnailSelected;

  const VideoThumbnailStrip({
    super.key,
    required this.thumbnailUrls,
    this.selectedIndex = 0,
    required this.onThumbnailSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: thumbnailUrls.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onThumbnailSelected(index),
            child: Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  thumbnailUrls[index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 24),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
