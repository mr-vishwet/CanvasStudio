import 'package:test/test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('Sticker', () {
    const sticker = Sticker(
      id: 'st_001',
      name: 'Diwali Diya',
      url: 'https://cdn.example.com/diya.png',
      categoryId: 'cat_festival',
      width: 120.0,
      height: 120.0,
    );

    test('toJson produces correct map', () {
      final json = sticker.toJson();
      expect(json['id'], 'st_001');
      expect(json['name'], 'Diwali Diya');
      expect(json['url'], 'https://cdn.example.com/diya.png');
      expect(json['category_id'], 'cat_festival');
      expect(json['width'], 120.0);
      expect(json['height'], 120.0);
    });

    test('fromJson reconstructs sticker correctly', () {
      final json = {
        'id': 'st_002',
        'name': 'Lakshmi Sticker',
        'url': 'https://cdn.example.com/lakshmi.png',
        'category_id': 'cat_religious',
        'width': 80.0,
        'height': 80.0,
      };
      final restored = Sticker.fromJson(json);
      expect(restored.id, 'st_002');
      expect(restored.name, 'Lakshmi Sticker');
      expect(restored.url, 'https://cdn.example.com/lakshmi.png');
      expect(restored.categoryId, 'cat_religious');
      expect(restored.width, 80.0);
      expect(restored.height, 80.0);
    });

    test('round-trip preserves data', () {
      final json = sticker.toJson();
      final restored = Sticker.fromJson(json);
      expect(restored.id, sticker.id);
      expect(restored.name, sticker.name);
      expect(restored.width, sticker.width);
    });

    test('default width and height are 100.0', () {
      const defaultSticker = Sticker(
        id: 'st_default',
        name: 'Default',
        url: 'https://cdn.example.com/default.png',
        categoryId: 'cat',
      );
      expect(defaultSticker.width, 100.0);
      expect(defaultSticker.height, 100.0);
    });
  });

  group('StickerCategory', () {
    test('creates with required fields', () {
      const category = StickerCategory(
        id: 'cat_001',
        name: 'Festival',
        iconUrl: 'https://cdn.example.com/cat_icon.png',
      );
      expect(category.id, 'cat_001');
      expect(category.name, 'Festival');
      expect(category.iconUrl, 'https://cdn.example.com/cat_icon.png');
    });

    test('iconUrl is optional', () {
      const category = StickerCategory(
        id: 'cat_002',
        name: 'Business',
      );
      expect(category.iconUrl, null);
    });
  });
}
