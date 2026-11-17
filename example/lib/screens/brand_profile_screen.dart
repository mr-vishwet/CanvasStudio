import 'package:flutter/material.dart';
import 'package:canvas_studio/canvas_studio.dart';
import '../providers/example_template_provider.dart';

class BrandProfileScreen extends StatefulWidget {
  final CanvasController controller;
  final ExampleTemplateProvider templateProvider;

  const BrandProfileScreen({
    super.key,
    required this.controller,
    required this.templateProvider,
  });

  @override
  State<BrandProfileScreen> createState() => _BrandProfileScreenState();
}

class _BrandProfileScreenState extends State<BrandProfileScreen> {
  final _businessNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _taglineController = TextEditingController();
  String? _logoUrl;

  @override
  void initState() {
    super.initState();
    _loadExistingBrandInfo();
  }

  void _loadExistingBrandInfo() {
    // Check if any layer has placeholder names and pre-fill
    for (final layer in widget.controller.layers) {
      if (layer is TextLayer) {
        if (layer.placeholderName == 'business_name') {
          _businessNameController.text = layer.text;
        } else if (layer.placeholderName == 'phone') {
          _phoneController.text = layer.text;
        } else if (layer.placeholderName == 'address') {
          _addressController.text = layer.text;
        } else if (layer.placeholderName == 'tagline') {
          _taglineController.text = layer.text;
        }
      } else if (layer is ImageLayer &&
          layer.placeholderName == 'logo') {
        _logoUrl = layer.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brand Profile'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Business Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _businessNameController,
              decoration: const InputDecoration(
                labelText: 'Business Name',
                hintText: 'e.g. Sharma Electronics',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                hintText: 'e.g. +91 98765 43210',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'e.g. Mumbai, India',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _taglineController,
              decoration: const InputDecoration(
                labelText: 'Tagline',
                hintText: 'e.g. Quality Products Since 1990',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Logo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_logoUrl != null)
              Column(
                children: [
                  Image.network(
                    _logoUrl!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 50),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => setState(() => _logoUrl = null),
                    child: const Text('Remove'),
                  ),
                ],
              )
            else
              OutlinedButton.icon(
                onPressed: _pickLogo,
                icon: const Icon(Icons.image),
                label: const Text('Pick Logo'),
              ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _applyBrand,
                child: const Text('Apply to Canvas'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickLogo() {
    // In a real app, this would use image_picker
    // For demo, show a dialog to enter a URL
    final controller = TextEditingController(text: _logoUrl ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logo URL'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'https://example.com/logo.png',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _logoUrl = controller.text);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _applyBrand() {
    widget.controller.applyBrandProfile(BrandProfile(
      businessName: _businessNameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      logoUrl: _logoUrl.isNotEmpty ? _logoUrl : null,
      tagline: _taglineController.text.isNotEmpty
          ? _taglineController.text
          : null,
    ));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Brand info applied to canvas')),
    );
  }
}
