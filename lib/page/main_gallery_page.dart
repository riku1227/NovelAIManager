import 'package:flutter/material.dart';
import 'package:novelai_manager/components/gallery_card.dart';
import 'package:novelai_manager/model/schema/gallery_schema.dart';
import 'package:novelai_manager/page/gallery_edit_page.dart';
import 'package:novelai_manager/page/prompt_info_page.dart';
import 'package:novelai_manager/repository/gallery_data_repository.dart';

/// 起動時に最初に表示されるページ
/// プロンプトデータ一覧のギャラリーが表示される
class MainGalleryPage extends StatefulWidget {
  const MainGalleryPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainGalleryPageState();
  }
}

class _MainGalleryPageState extends State<MainGalleryPage> {
  //ギャラリーのデータ一覧が入るリスト
  List<GalleryData> galleryDataList = List.empty();

  //データベースからギャラリーデータを読み込む
  Future<bool> loadGalleryDatabase() async {
    final repository = await GalleryDataRepository.getInstance();

    //リポジトリのストリームに登録する
    //データが送られてきたらリストを更新してUIも更新する
    repository.streamController.stream.listen((event) {
      setState(() {
        galleryDataList = event.toList();
      });
    });

    //ギャラリー一覧を取得
    final list = repository.getAllGallery();
    if (list != null) {
      //FutureBuilderで使用しているためsetStateの必要なし
      galleryDataList = list;
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  /// ギャラリーカードのグリッドを作成する
  Widget buildGalleryGridView(BuildContext context) {
    return Wrap(
      children: galleryDataList.map(
        (value) {
          return GalleryCard(
            galleryData: value,
            onTap: (galleryData) {
              Navigator.push(context, PromptInfoPage.getRoute(galleryData));
            },
          );
        },
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NovelAI Manager"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, GalleryEditPage.getRoute());
        },
        icon: const Icon(Icons.photo),
        label: const Text("ギャラリーを追加"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: FutureBuilder(
              future: loadGalleryDatabase(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!) {
                    return buildGalleryGridView(context);
                  } else {
                    return const Text("読み込みエラーが発生しました");
                  }
                } else {
                  return const Text("読み込み中...");
                }
              }),
            ),
          ),
        ),
      ),
    );
  }
}