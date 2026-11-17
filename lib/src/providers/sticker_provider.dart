class Sticker {
  final String id;
  final String name;
  final String url;
  final String categoryId;
  final double width;
  final double height;

  const Sticker({
    required this.id,
    required this.name,
    required this.url,
    required this.categoryId,
    this.width = 100.0,
    this.height = 100.0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'url': url,
    'category_id': categoryId,
    'width': width,
    'height': height,
  };

  factory Sticker.fromJson(Map<String, dynamic> json) => Sticker(
    id: json['id'] as String,
    name: json['name'] as String,
    url: json['url'] as String,
    categoryId: json['category_id'] as String,
    width: (json['width'] as num).toDouble(),
    height: (json['height'] as num).toDouble(),
  );
}

class StickerCategory {
  final String id;
  final String name;
  final String? iconUrl;

  const StickerCategory({
    required this.id,
    required this.name,
    this.iconUrl,
  });
}

abstract class StickerProvider {
  Future<List<StickerCategory>> fetchCategories();
  Future<List<Sticker>> fetchStickers({String? categoryId, int page = 1});
}
