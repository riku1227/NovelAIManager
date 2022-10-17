import 'package:flutter/material.dart';
import 'package:novelai_manager/page/main_gallery_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NovelAI Manager',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF13152c),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const MainGalleryPage(),
    );
  }
}
