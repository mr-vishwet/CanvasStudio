import 'package:flutter/material.dart';
import 'package:canvas_studio/canvas_studio.dart';
import '../providers/example_template_provider.dart';
import '../providers/example_audio_provider.dart';
import '../providers/example_sticker_provider.dart';
import 'editor_screen.dart';

class TemplatePickerScreen extends StatefulWidget {
  const TemplatePickerScreen({super.key});

  @override
  State<TemplatePickerScreen> createState() => _TemplatePickerScreenState();
}

class _TemplatePickerScreenState extends State<TemplatePickerScreen> {
  final ExampleTemplateProvider _templateProvider = ExampleTemplateProvider();
  final ExampleAudioProvider _audioProvider = ExampleAudioProvider();
  final ExampleStickerProvider _stickerProvider = ExampleStickerProvider();

  List<TemplateManifest> _templates = [];
  bool _isLoading = true;
  String? _selectedCategory;
  TemplateAspectRatio? _selectedRatio;

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    final templates = await _templateProvider.fetchTemplates();
    setState(() {
      _templates = templates;
      _isLoading = false;
    });
  }

  void _filterTemplates({String? category, TemplateAspectRatio? ratio}) {
    setState(() {
      _selectedCategory = category;
      _selectedRatio = ratio;
      _isLoading = true;
    });
    _templateProvider
        .fetchTemplates(category: category, ratio: ratio)
        .then((templates) {
      setState(() {
        _templates = templates;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Template'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildFilterTabs(),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _templates.length,
                    itemBuilder: (context, index) {
                      final template = _templates[index];
                      return _buildTemplateCard(template);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterTabs() {
    final categories = ['All', 'blank', 'business', 'sale', 'festival', 'video'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory == cat || 
              (cat == 'All' && _selectedCategory == null);
          return FilterChip(
            label: Text(cat),
            selected: isSelected,
            onSelected: (selected) {
              _filterTemplates(
                category: cat == 'All' ? null : cat,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTemplateCard(TemplateManifest template) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      template.type == 'video' ? Icons.videocam : Icons.image,
                      size: 48,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      template.ratio.name,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  template.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  template.category ?? '',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _selectTemplate(template),
              child: const Text('Select'),
            ),
          ),
        ],
      ),
    );
  }

  void _selectTemplate(TemplateManifest template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditorScreen(
          template: template,
          templateProvider: _templateProvider,
          audioProvider: _audioProvider,
          stickerProvider: _stickerProvider,
        ),
      ),
    );
  }
}
