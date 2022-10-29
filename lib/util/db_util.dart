import 'dart:io';

import 'package:novelai_manager/novelai_manager.dart';
import 'package:path_provider/path_provider.dart';

class DBUtil {
  /// データベースを保存するベースディレクトリを返す
  static Future<Directory> getDataBaseFolder() async {
    //実行ファイルがあるフォルダの場所
    var exeFolderPath = File(Platform.resolvedExecutable).parent;

    /// macOS向けは.app単体で配布する形式なのとファイルアクセス権限周りの関係で
    /// Application Supportのディレクトリにデータベースを保存するようにする
    /// 「~/Library/Application Support/com.riku1227.novelaiManager」
    if (Platform.isMacOS) {
      exeFolderPath = await getApplicationSupportDirectory();
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
  static Future<String?> getImageFullPath(String relativePath) async {
    final imgDir = await DBUtil.getDataBaseImgFolder();
    final imgFilePath = "${imgDir.path}/$relativePath";
    if (await File(imgFilePath).exists()) {
      return imgFilePath;
    }

    /// 与えられたパスが実はフルパスだった場合はそのまま返す
    if (await File(relativePath).exists()) {
      return relativePath;
    }

    /// Future.errorを大量に返すとクラッシュする...？
    /// デバッグ環境のみもしくはmacOSのみ...？
    /// その対策でnullを返すようにする
    /// 読み込み中か読み込みエラーかとかが判別できないから良いコードでは無い
    return null;
  }
}
