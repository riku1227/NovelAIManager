import 'dart:io';

import 'package:novelai_manager/novelai_manager.dart';

class DBUtil {
  /// データベースを保存するベースディレクトリを返す
  static Future<Directory> getDataBaseFolder() async {
    //実行ファイルがあるフォルダの場所
    var exeFolderPath = File(Platform.resolvedExecutable).parent;

    /// MacOSだと"Folder/novelai_manager.app/Contents/MacOS"となり
    /// windowsでいうexeファイルの中になってしまうので(中のファイルを開いて編集することはできるけど)
    /// .appがあるフォルダまで戻る
    if (Platform.isMacOS) {
      exeFolderPath = exeFolderPath.parent.parent.parent;
    }
    //データベースのディレクトリ
    final dbDir =
        Directory("${exeFolderPath.path}/${NovelAIManager.baseDBFolderName}");

    //ディレクトリが無い場合は作成する
    if (!await dbDir.exists()) {
      await dbDir.create();
    }

    return dbDir;
  }

  /// データーベースの画像を保存するディレクトリを返す
  static Future<Directory> getDataBaseImgFolder() async {
    var dbDir = await getDataBaseFolder();
    //画像を保存するディレクトリ
    var imgFolder = Directory("${dbDir.path}/images");

    //ディレクトリが無い場合は作成する
    if (!await imgFolder.exists()) {
      await imgFolder.create();
    }

    return imgFolder;
  }

  /// DBに保存されている相対パスから画像ファイルのフルパスを取得する
  static Future<String> getImageFullPath(String relativePath) async {
    final imgDir = await DBUtil.getDataBaseImgFolder();
    final imgFilePath = "${imgDir.path}/$relativePath";
    if (await File(imgFilePath).exists()) {
      return imgFilePath;
    }

    /// 与えられたパスが実はフルパスだった場合はそのまま返す
    if (await File(relativePath).exists()) {
      return relativePath;
    }

    return Future.error("画像が存在しません");
  }
}
