import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canvas Studio Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        useMaterial3: true,
      ),
      home: const ExampleEditorScreen(),
    );
  }
}

class ExampleEditorScreen extends StatefulWidget {
  const ExampleEditorScreen({super.key});

  @override
  State<ExampleEditorScreen> createState() => _ExampleEditorScreenState();
}

class _ExampleEditorScreenState extends State<ExampleEditorScreen> {
  late final CanvasController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CanvasController.empty(
      canvasSize: const Size(1080, 1080),
    );
    _addTestLayers();
  }

  void _addTestLayers() {
    // Background shape
    _controller.addLayer(ShapeLayer(
      id: 'bg',
      name: 'Background',
      position: Offset.zero,
      size: const Size(1080, 1080),
      shapeType: ShapeType.rectangle,
      fillColor: const Color(0xFF1A1A2E),
    ));

    // Title text
    _controller.addLayer(TextLayer(
      id: 'title',
      name: 'Title',
      position: const Offset(80, 400),
      size: const Size(920, 120),
      text: 'Canvas Studio',
      fontFamily: 'Roboto',
      fontSize: 72,
      fontWeight: FontWeight.bold,
      color: const Color(0xFFFFFFFF),
      alignment: TextAlignment.center,
    ));

    // Subtitle text
    _controller.addLayer(TextLayer(
      id: 'subtitle',
      name: 'Subtitle',
      position: const Offset(80, 540),
      size: const Size(920, 60),
      text: 'Flutter SDK for design creation',
      fontFamily: 'Roboto',
      fontSize: 32,
      color: const Color(0xFFB0BEC5),
      alignment: TextAlignment.center,
    ));

    // Accent shape
    _controller.addLayer(ShapeLayer(
      id: 'accent',
      name: 'Accent',
      position: const Offset(440, 300),
      size: const Size(200, 6),
      shapeType: ShapeType.rectangle,
      fillColor: const Color(0xFF6750A4),
      cornerRadius: 3,
    ));

    // Reset history so test layers don't pollute undo stack
    _controller.loadDocument(_controller.document);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: CanvasEditorWidget(
          controller: _controller,
          config: CanvasEditorConfig.defaults,
          canvasBackground: const Color(0xFF1A1A2E),
          onEditorReady: () => debugPrint('Editor ready'),
          onExportImage: (result) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Saved to ${result.friendlyPath}'),
                action: SnackBarAction(label: 'OK', onPressed: () {}),
              ),
            );
          },
          onExportError: (err) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Export failed: $err'),
                backgroundColor: Colors.red,
              ),
            );
          },
          onFeatureLocked: (feature) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${feature.name} requires upgrade'),
                action: SnackBarAction(label: 'Upgrade', onPressed: () {}),
              ),
            );
          },
        ),
      ),
    );
  }
}
