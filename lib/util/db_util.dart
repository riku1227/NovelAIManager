import 'dart:io';

import 'package:novelai_manager/repository/gallery_data_repository.dart';

class DBUtil {
  /// DBに保存されている相対パスから画像ファイルのパスを取得する
  static Future<String> getImageFullPath(String relativePath) async {
    var imgFolder = await GalleryDataRepository.getDataBaseImgFolder();
    var imgFilePath = "${imgFolder.path}/$relativePath";
    if (await File(imgFilePath).exists()) {
      return imgFilePath;
    }

    //与えられたパスにファイルが存在してた場合はそのまま返す
    if (await File(relativePath).exists()) {
      return relativePath;
    }

    return "";
  }
}
