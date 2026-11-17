import 'package:canvas_studio/canvas_studio.dart';
import 'dart:convert';

class ExampleTemplateProvider implements TemplateProvider {
  final List<TemplateManifest> _templates;

  ExampleTemplateProvider() : _templates = _loadTemplates();

  static List<TemplateManifest> _loadTemplates() {
    return [
      TemplateManifest(
        schemaVersion: '1.0',
        id: 'tpl_blank_square',
        name: 'Blank Square',
        category: 'blank',
        tags: ['blank', 'square', 'starter'],
        ratio: TemplateAspectRatio.square_1x1,
        canvasSize: const Size(1080, 1080),
        type: 'image',
        source: TemplateSource.self_hosted,
        layers: [],
      ),
      TemplateManifest(
        schemaVersion: '1.0',
        id: 'tpl_blank_portrait',
        name: 'Blank Portrait',
        category: 'blank',
        tags: ['blank', 'portrait', 'starter'],
        ratio: TemplateAspectRatio.portrait_9x16,
        canvasSize: const Size(1080, 1920),
        type: 'image',
        source: TemplateSource.self_hosted,
        layers: [],
      ),
      TemplateManifest(
        schemaVersion: '1.0',
        id: 'tpl_business_card',
        name: 'Business Card',
        category: 'business',
        tags: ['business', 'card', 'professional'],
        ratio: TemplateAspectRatio.landscape_16x9,
        canvasSize: const Size(1080, 608),
        type: 'image',
        source: TemplateSource.self_hosted,
        layers: [
          {
            'id': 'l1',
            'type': 'text',
            'name': 'Business Name',
            'z_index': 0,
            'placeholder_name': 'business_name',
            'position': {'x': 100, 'y': 200},
            'size': {'width': 400, 'height': 60},
            'rotation': 0,
            'opacity': 1.0,
            'is_visible': true,
            'is_locked': false,
            'text': 'Your Business Name',
            'font_family': 'Roboto',
            'font_size': 32,
            'font_weight': 'bold',
            'color': '#FFFFFFFF',
            'alignment': 'left',
          },
          {
            'id': 'l2',
            'type': 'text',
            'name': 'Phone',
            'z_index': 1,
            'placeholder_name': 'phone',
            'position': {'x': 100, 'y': 280},
            'size': {'width': 300, 'height': 40},
            'rotation': 0,
            'opacity': 1.0,
            'is_visible': true,
            'is_locked': false,
            'text': '+91 00000 00000',
            'font_family': 'Roboto',
            'font_size': 24,
            'font_weight': 'regular',
            'color': '#FFFFFFFF',
            'alignment': 'left',
          },
          {
            'id': 'l3',
            'type': 'image',
            'name': 'Logo',
            'z_index': 2,
            'placeholder_name': 'logo',
            'position': {'x': 600, 'y': 150},
            'size': {'width': 120, 'height': 120},
            'rotation': 0,
            'opacity': 1.0,
            'is_visible': true,
            'is_locked': false,
            'image_url': '',
          },
        ],
      ),
      TemplateManifest(
        schemaVersion: '1.0',
        id: 'tpl_sale_poster',
        name: 'Sale Poster',
        category: 'sale',
        tags: ['sale', 'poster', 'festival'],
        ratio: TemplateAspectRatio.portrait_9x16,
        canvasSize: const Size(1080, 1920),
        type: 'image',
        source: TemplateSource.self_hosted,
        layers: [
          {
            'id': 'l1',
            'type': 'text',
            'name': 'Headline',
            'z_index': 0,
            'placeholder_name': 'business_name',
            'position': {'x': 80, 'y': 400},
            'size': {'width': 920, 'height': 120},
            'rotation': 0,
            'opacity': 1.0,
            'is_visible': true,
            'is_locked': false,
            'text': 'Big Sale!',
            'font_family': 'Roboto',
            'font_size': 72,
            'font_weight': 'bold',
            'color': '#FFFFFFFF',
            'alignment': 'center',
          },
          {
            'id': 'l2',
            'type': 'text',
            'name': 'Subhead',
            'z_index': 1,
            'placeholder_name': 'tagline',
            'position': {'x': 80, 'y': 540},
            'size': {'width': 920, 'height': 60},
            'rotation': 0,
            'opacity': 1.0,
            'is_visible': true,
            'is_locked': false,
            'text': 'Up to 50% off',
            'font_family': 'Roboto',
            'font_size': 32,
            'font_weight': 'regular',
            'color': '#FFB0BEC5',
            'alignment': 'center',
          },
        ],
      ),
      TemplateManifest(
        schemaVersion: '1.0',
        id: 'tpl_festival_post',
        name: 'Festival Post',
        category: 'festival',
        tags: ['festival', 'diwali', 'post'],
        ratio: TemplateAspectRatio.square_1x1,
        canvasSize: const Size(1080, 1080),
        type: 'image',
        source: TemplateSource.self_hosted,
        layers: [
          {
            'id': 'l1',
            'type': 'text',
            'name': 'Greeting',
            'z_index': 0,
            'placeholder_name': 'business_name',
            'position': {'x': 100, 'y': 300},
            'size': {'width': 880, 'height': 100},
            'rotation': 0,
            'opacity': 1.0,
            'is_visible': true,
            'is_locked': false,
            'text': 'Happy Diwali',
            'font_family': 'NotoSansDevanagari',
            'font_size': 64,
            'font_weight': 'bold',
            'color': '#FFFFFFFF',
            'alignment': 'center',
            'is_indic_script': true,
          },
        ],
      ),
      TemplateManifest(
        schemaVersion: '1.0',
        id: 'tpl_video_slideshow',
        name: 'Video Slideshow',
        category: 'video',
        tags: ['video', 'slideshow', 'audio'],
        ratio: TemplateAspectRatio.square_1x1,
        canvasSize: const Size(1080, 1080),
        type: 'video',
        videoDurationMs: 15000,
        source: TemplateSource.self_hosted,
        defaultAudioId: 'audio_festival_01',
        layers: [
          {
            'id': 'l1',
            'type': 'text',
            'name': 'Video Title',
            'z_index': 0,
            'placeholder_name': 'business_name',
            'position': {'x': 100, 'y': 400},
            'size': {'width': 880, 'height': 80},
            'rotation': 0,
            'opacity': 1.0,
            'is_visible': true,
            'is_locked': false,
            'text': 'Your Video Title',
            'font_family': 'Roboto',
            'font_size': 48,
            'font_weight': 'semiBold',
            'color': '#FFFFFFFF',
            'alignment': 'center',
            'entrance_animation': {
              'type': 'fade',
              'start_time_seconds': 0,
              'duration_seconds': 1,
            },
            'exit_animation': {
              'type': 'slideUp',
              'start_time_seconds': 12,
              'duration_seconds': 1,
            },
          },
        ],
      ),
    ];
  }

  @override
  Future<List<TemplateManifest>> fetchTemplates({
    String? category,
    TemplateAspectRatio? ratio,
    int page = 1,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    var filtered = _templates.where((t) {
      if (category != null && t.category != category) return false;
      if (ratio != null && t.ratio != ratio) return false;
      return true;
    }).toList();

    // Pagination: 10 per page
    final start = (page - 1) * 10;
    final end = start + 10;
    if (start >= filtered.length) return [];
    return filtered.sublist(start, min(end, filtered.length));
  }

  @override
  Future<TemplateManifest?> fetchTemplateById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _templates.firstWhere(
      (t) => t.id == id,
      orElse: () => throw StateError('Template $id not found'),
    );
  }
}

int min(int a, int b) => a < b ? a : b;
