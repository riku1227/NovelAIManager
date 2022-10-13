import 'package:flutter/material.dart';
import 'package:novelai_manager/components/gallery_gird_view.dart';
import 'package:novelai_manager/model/gallery_data.dart';
import 'package:novelai_manager/page/create_gallery_page.dart';
import 'package:novelai_manager/repository/gallery_data_repository.dart';
import 'dart:io';

import 'components/gallery_card.dart';
import 'settings/custom_scroll_behavior.dart';

void main() async {
  //ここら辺はおまじない
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NovelAI Manager',
      scrollBehavior: CustomScrollBehavior(),
      theme: ThemeData(
          colorSchemeSeed: const Color(0xFF13152c),
          useMaterial3: true,
          brightness: Brightness.dark),
      home: const MyHomePage(title: 'NovelAI Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //ギャラリーのデータが入るリスト
  List<GalleryData> galleryDataList = List.empty();

  //データベースからデータをロードする
  Future<bool> loadDataBase() async {
    var repository = await GalleryDataRepository.getInstance();

    //リポジトリのストリームに登録する
    repository.streamController.stream.listen((event) {
      setState(() {
        galleryDataList = event.toList();
      });
    });

    //ギャラリーのデータリストを取得する
    var list = repository.getAllGallery();
    if (list != null) {
      //FutureBuilder使ってるからここでのUI更新は要らない
      galleryDataList = list;
      return true;
    } else {
      return Future.error("読み込みエラー");
    }
  }

  @override
  void initState() {
    //データベースを読み込む
    loadDataBase();
    super.initState();
  }

  void createGallery(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: ((context) {
      return CreateGalleryPage();
    })));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: FutureBuilder(
              future: loadDataBase(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GalleryGridView(galleryDataList: galleryDataList);
                } else {
                  return const Text("ロード中");
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          createGallery(context);
        },
        label: const Text("ギャラリーを追加"),
        icon: const Icon(Icons.add),
        heroTag: "main_gallery_hero",
      ),
    );
  }
}
