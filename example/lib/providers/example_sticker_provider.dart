import 'package:canvas_studio/canvas_studio.dart';

class ExampleStickerProvider implements StickerProvider {
  final List<StickerCategory> _categories;
  final List<Sticker> _stickers;

  ExampleStickerProvider()
      : _categories = _loadCategories(),
        _stickers = _loadStickers();

  static List<StickerCategory> _loadCategories() {
    return [
      const StickerCategory(id: 'cat_festival', name: 'Festival', iconUrl: null),
      const StickerCategory(id: 'cat_business', name: 'Business', iconUrl: null),
      const StickerCategory(id: 'cat_emoji', name: 'Emoji', iconUrl: null),
    ];
  }

  static List<Sticker> _loadStickers() {
    return [
      const Sticker(
        id: 's_diya',
        name: 'Diwali Diya',
        url: 'https://cdn.example.com/stickers/diya.png',
        categoryId: 'cat_festival',
        width: 100,
        height: 100,
      ),
      const Sticker(
        id: 's_lakshmi',
        name: 'Lakshmi',
        url: 'https://cdn.example.com/stickers/lakshmi.png',
        categoryId: 'cat_festival',
        width: 100,
        height: 100,
      ),
      const Sticker(
        id: 's_logo_placeholder',
        name: 'Logo Placeholder',
        url: 'https://cdn.example.com/stickers/logo_placeholder.png',
        categoryId: 'cat_business',
        width: 100,
        height: 100,
      ),
      const Sticker(
        id: 's_smile',
        name: 'Smiley',
        url: 'https://cdn.example.com/stickers/smile.png',
        categoryId: 'cat_emoji',
        width: 80,
        height: 80,
      ),
      const Sticker(
        id: 's_heart',
        name: 'Heart',
        url: 'https://cdn.example.com/stickers/heart.png',
        categoryId: 'cat_emoji',
        width: 80,
        height: 80,
      ),
    ];
  }

  @override
  Future<List<StickerCategory>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _categories;
  }

  @override
  Future<List<Sticker>> fetchStickers({String? categoryId, int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    var filtered = _stickers.where((s) {
      if (categoryId != null && s.categoryId != categoryId) return false;
      return true;
    }).toList();

    final start = (page - 1) * 20;
    final end = start + 20;
    if (start >= filtered.length) return [];
    return filtered.sublist(start, min(end, filtered.length));
  }
}

int min(int a, int b) => a < b ? a : b;
