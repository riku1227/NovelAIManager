import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:novelai_manager/components/gallery_card.dart';
import 'package:novelai_manager/model/schema/gallery_schema.dart';
import 'package:novelai_manager/novelai_manager.dart';
import 'package:novelai_manager/page/gallery_edit_page.dart';
import 'package:novelai_manager/page/png_metadata_viewer_page.dart';
import 'package:novelai_manager/page/prompt_info_page.dart';
import 'package:novelai_manager/page/settings_page.dart';
import 'package:novelai_manager/repository/gallery_data_repository.dart';
import 'package:novelai_manager/repository/settings_repository.dart';
import 'package:novelai_manager/util/db_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;

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

  /// ソフトの更新があるかどうかを確認する
  /// 更新があった場合はスナックバーを出す
  Future<void> checkUpdate(BuildContext context) async {
    //BuildContextを非同期処理した後に使うと怒られるので、先に使う
    var messenger = ScaffoldMessenger.of(context);

    //現在の設定を取得
    var settings = await SettingsRepository.getSetting();
    //自動更新確認がオフの場合は更新の確認をせずに処理を終了する
    if (!settings.isAutoCheckForUpdates) {
      print("aaaa");
      return;
    }

    //アップデートの情報を取得するURL
    var updateCheckUrl = Uri.parse(
        "https://raw.githubusercontent.com/riku1227/NovelAIManager/files/version.json");
    var respone = await http.get(updateCheckUrl);
    if (respone.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(respone.body);
      if (json.containsKey("version_code")) {
        if (NovelAIManager.versionCode < json["version_code"]) {
          var snackBar = SnackBar(
            content: Text('アップデートがあります: ${json["version"]}'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: "ダウンロードページを開く",
              onPressed: () {
                launchUrlString(json["download_url"]);
              },
            ),
          );
          messenger.showSnackBar(snackBar);
        }
      }
    }
  }

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
    checkUpdate(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("NovelAI Manager"),
        actions: [
          IconButton(
            tooltip: "データベースフォルダを開く",
            onPressed: () async {
              final dbFilePath = await DBUtil.getDataBaseFolder();
              final url = "file:${dbFilePath.path}";

              /// Windowsで"launchUrl"だとURLに日本語が含まれている場合開かなかった
              /// macOSは"launchUrlString"を使うとエラーを吐くのとDBの保存場所的に多分日本語は入ってこない
              if (Platform.isWindows) {
                launchUrlString(url);
              } else if (Platform.isMacOS) {
                launchUrl(Uri.parse(url));
              }
            },
            icon: const Icon(Icons.folder),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 82,
                    height: 82,
                    child: Image.asset("assets/images/icon.png"),
                  ),
                  Text(
                    "NovelAI Manager",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("PNGのメタデータを見る"),
              onTap: () {
                Navigator.push(context, PNGMetaDataViewerPage.getRoute());
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("設定"),
              onTap: () {
                Navigator.push(context, SettingsPage.getRoute());
              },
            ),
          ],
        ),
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
