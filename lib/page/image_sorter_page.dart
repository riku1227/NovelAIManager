import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novelai_manager/components/widget/outline_container.dart';
import 'package:novelai_manager/model/json/manager_setting.dart';
import 'package:novelai_manager/page/setting/image_sorter_setting_page.dart';
import 'package:novelai_manager/repository/settings_repository.dart';
import 'package:path/path.dart';

/// 画像を選別する機能のページ
class ImageSorter extends StatefulWidget {
  const ImageSorter({Key? key}) : super(key: key);

  /// Navigator用のRouteを取得する
  static MaterialPageRoute getRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return const ImageSorter();
      },
    );
  }

  @override
  State<StatefulWidget> createState() => _ImageSorterState();
}

class _ImageSorterState extends State<ImageSorter> {
  //画像を読み込んでたらtrue
  bool isLoaded = false;

  //画像のファイルパスを入れるリスト
  List<String> imageFilePathList = [];

  //表示される画像のファイルパスを入れておく
  String nowImage = "";

  //画像を移動させるフォルダの親フォルダ
  Directory? parentDir;

  //フォルダ選択ダイアログでフォルダを選択する
  void pickFolder() async {
    final filePath = await FilePicker.platform.getDirectoryPath();
    if (filePath == null) {
      return;
    }

    final dir = Directory(filePath);

    // 一応フォルダが存在してるかチェックする
    if (!dir.existsSync()) {
      return;
    }

    imageFilePathList.clear();

    for (var value in dir.listSync()) {
      // ファイルだった場合処理を進む (サブディレクトリの中には入らない)
      // そしてファイルがpngファイルだった場合、追加する
      if (value is File && extension(value.path) == ".png") {
        imageFilePathList.add(value.path);
      }
    }

    onLoadedImageList();
  }

  //ファイル / フォルダ をドラッグアンドドロップしたときの処理
  void onDragDone(DropDoneDetails details) async {
    if (details.files.isEmpty) {
      return;
    }

    imageFilePathList.clear();

    for (var value in details.files) {
      if (FileSystemEntity.isDirectorySync(value.path)) {
        for (var file in Directory(value.path).listSync()) {
          if (extension(file.path) == ".png") {
            imageFilePathList.add(file.path);
          }
        }
      } else {
        if (extension(value.path) == ".png") {
          imageFilePathList.add(value.path);
        }
      }
    }

    onLoadedImageList();
  }

  //画像が読み込まれた後の処理
  void onLoadedImageList() async {
    final settings = await SettingsRepository.getSetting();
    if (settings.imageSorterSetting.isRandomDisplay) {
      imageFilePathList.shuffle();
    }

    setState(() {
      if (imageFilePathList.isEmpty) {
        isLoaded = false;
      } else {
        nowImage = imageFilePathList[0];
        parentDir = File(nowImage).parent;
        isLoaded = true;
      }
    });
  }

  void sortImage(String folderName) async {
    //フォルダ名が空だったらファイルを操作しない
    if (folderName.isNotEmpty) {
      final settings = await SettingsRepository.getSetting();
      //移動先のディレクトリ
      final moveDir = Directory("${parentDir!.path}/$folderName");
      if (!moveDir.existsSync()) {
        moveDir.createSync();
      }

      final movePath = "${moveDir.path}/${basename(nowImage)}";

      if (settings.imageSorterSetting.isCopyFile) {
        File(nowImage).copy(movePath);
      } else {
        File(nowImage).renameSync(movePath);
      }
    }

    setState(() {
      imageFilePathList.removeAt(0);
      if (imageFilePathList.isEmpty) {
        isLoaded = false;
      } else {
        nowImage = imageFilePathList[0];
      }
    });
  }

  //画像のリストが読み込まれていないときにビルドされるウィジェット
  Widget notLoadedWidgetBuild() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          message: "D&Dで読み込むこともできます",
          child: OutlinedButton(
            onPressed: () {
              pickFolder();
            },
            child: const Text("フォルダを読み込む"),
          ),
        ),
      ],
    );
  }

  //画像のリストが読み込まれた時にビルドされるウィジェット
  Widget loadedWidgetBuild(ManagerSetting settings) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: loadedWidgetViewArea(),
        ),
        Expanded(
          flex: 3,
          child: loadedWidgetControlArea(settings),
        ),
      ],
    );
  }

  Widget loadedWidgetViewArea() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: OutlineContainer(
        child: SizedBox(
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.file(
              File(nowImage),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget loadedWidgetControlArea(ManagerSetting settings) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: ListView.builder(
        itemCount: settings.imageSorterSetting.buttons.length,
        reverse: true,
        itemBuilder: (context, index) {
          final button = settings.imageSorterSetting
              .buttons[settings.imageSorterSetting.buttons.length - 1 - index];
          return Padding(
            padding: const EdgeInsets.only(
              top: 4,
              bottom: 4,
            ),
            child: SizedBox(
              height: 64,
              child: Tooltip(
                message: "\"${button.folderName}/\"に移動/コピーします",
                child: FilledButton(
                  onPressed: () => sortImage(button.folderName),
                  child: Text("${button.label} ${button.keys.toString()}"),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Sorter"),
        actions: [
          Tooltip(
            message: "Image Sorterの設定を開く",
            child: IconButton(
              onPressed: () async {
                await Navigator.push(
                    context, ImageSorterSettingPage.getRoute());
                setState(() {});
              },
              icon: const Icon(Icons.settings),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: SettingsRepository.getSetting(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final settings = snapshot.data!;
            return Center(
              child: DropTarget(
                onDragDone: (details) => onDragDone(details),
                child: Focus(
                  autofocus: true,
                  onKeyEvent: (node, event) {
                    if (event is KeyDownEvent) {
                      for (var button in settings.imageSorterSetting.buttons) {
                        if (button.keys.contains(event.character)) {
                          sortImage(button.folderName);
                        }
                      }
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: SizedBox(
                    width: size.width,
                    height: size.height,
                    child: isLoaded
                        ? loadedWidgetBuild(settings)
                        : notLoadedWidgetBuild(),
                  ),
                ),
              ),
            );
          } else {
            return const Text("設定を読み込み中");
          }
        },
      ),
    );
  }
}
