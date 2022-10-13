import 'dart:async';
import 'dart:io';

import 'package:realm/realm.dart';

import '../model/gallery_data.dart';

class GalleryDataRepository {
  //シングルトン用のインスタンス
  static GalleryDataRepository? _instance;

  //データベース
  Realm realm;

  //DBの変更を通知、値を送信するストリーム
  var streamController =
      StreamController<RealmResults<GalleryData>>.broadcast();

  //コンストラクタ
  GalleryDataRepository(this.realm);

  /// データベースのファイルが保存されるディレクトリを返す
  static Future<Directory> getDataBaseFolder() async {
    var exePath = File(Platform.resolvedExecutable);
    var dbDir = Directory("${exePath.parent.path}/gallery_db");
    if (!await dbDir.exists()) {
      await dbDir.create();
    }

    return dbDir;
  }

  /// データベースの画像が保存されるディレクトリを返す
  static Future<Directory> getDataBaseImgFolder() async {
    var dbDir = await getDataBaseFolder();
    var imgFolder = Directory("${dbDir.path}/images");
    if (!await imgFolder.exists()) {
      await imgFolder.create();
    }

    return imgFolder;
  }

  //インスタンスを取得する
  //生成されてない場合は生成して返す
  static Future<GalleryDataRepository> getInstance() async {
    //インスタンスがまだ生成されていなかった場合生成する
    if (_instance == null) {
      var dbDir = await getDataBaseFolder();

      var config = Configuration.local([
        GalleryData.schema,
        FolderData.schema,
        PromptData.schema,
        ImageData.schema,
      ], path: "${dbDir.path}/gallery_db.realm");

      var realm = Realm(config);

      _instance = GalleryDataRepository(realm);
    }
    return _instance!;
  }

  //全てのギャラリーを取得する
  List<GalleryData>? getAllGallery() {
    if (realm.isClosed) {
      return null;
    }

    return realm.all<GalleryData>().toList();
  }

  //ギャラリーを追加
  Future<void> addGallery(GalleryData galleryData) async {
    if (realm.isClosed) {
      return;
    }
    if (!galleryData.isFolder) {
      realm.write(() {
        realm.add(galleryData, update: true);
        streamController.sink.add(realm.all<GalleryData>());
      });
    }
  }

  //ギャラリーを削除
  Future<void> deleteGallery(GalleryData galleryData) async {
    if (realm.isClosed) {
      return;
    }

    realm.write(() {
      if (galleryData.promptData != null) {
        realm.deleteMany(galleryData.promptData!.generatedImageList);

        realm.delete(galleryData.promptData!);
      }

      realm.delete(galleryData);
      streamController.sink.add(realm.all<GalleryData>());
    });
  }
}
