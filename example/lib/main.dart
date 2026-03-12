import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:canvas_studio/canvas_studio.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'canvas_studio example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const EditorScreen(),
    );
  }
}

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  // TODO: replace with real CanvasController once implemented
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('canvas_studio')),
      body: const Center(
        child: Text('canvas_studio SDK — ready to build!'),
      ),
    );
  }
}
