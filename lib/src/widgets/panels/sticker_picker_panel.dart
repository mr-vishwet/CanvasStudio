import 'package:flutter/material.dart';
import '../../providers/sticker_provider.dart';

class StickerPickerPanel extends StatelessWidget {
  final List<Sticker> stickers;
  final ValueChanged<Sticker> onStickerSelected;

  const StickerPickerPanel({
    super.key,
    required this.stickers,
    required this.onStickerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
      ),
      itemCount: stickers.length,
      itemBuilder: (context, index) {
        final sticker = stickers[index];
        return GestureDetector(
          onTap: () => onStickerSelected(sticker),
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  sticker.url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                ),
              ),
              Text(sticker.name, style: const TextStyle(fontSize: 10)),
            ],
          ),
        );
      },
    );
  }
}
