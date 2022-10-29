import 'dart:async';
import 'dart:io';

import 'package:novelai_manager/util/db_util.dart';
import 'package:realm/realm.dart';

import '../model/schema/gallery_schema.dart';

/// ギャラリーデータのデータベースを良い感じに扱う用のクラス
/// シングルトンインスタンス
class GalleryDataRepository {
  //シングルトン用
  static GalleryDataRepository? _instance;
  //データベースのファイル名
  static const dbFileName = "gallery_db.realm";

  //データベース
  Realm realm;

  //DBの変更を通知、値を送信するストリーム
  var streamController =
      StreamController<RealmResults<GalleryData>>.broadcast();

  //コンストラクタ
  GalleryDataRepository(this.realm);

  /// リポジトリのインスタンスを取得する
  /// インスタンがまだ生成されていない場合は生成する
  static Future<GalleryDataRepository> getInstance() async {
    if (_instance == null) {
      var dbDir = await DBUtil.getDataBaseFolder();

      /// Realmデータベースのコンフィグ
      /// スキーマの登録とDBファイルの保存パスを指定
      var config = Configuration.local([
        GalleryData.schema,
        FolderData.schema,
        PromptData.schema,
        ImageData.schema,
      ], path: "${dbDir.path}/$dbFileName");

      var realm = Realm(config);

      _instance = GalleryDataRepository(realm);
    }

    return _instance!;
  }

  /// 全てのギャラリーを取得する
  List<GalleryData>? getAllGallery() {
    if (realm.isClosed) {
      return null;
    }

    return realm.all<GalleryData>().toList();
  }

  /// ギャラリーを追加する
  Future<void> addGallery(GalleryData galleryData) async {
    if (realm.isClosed) {
      return;
    }

    if (!galleryData.isFolder) {
      realm.write(() {
        realm.add(galleryData, update: true);
        //ストリームに追加後のデータを送る
        streamController.sink.add(realm.all<GalleryData>());
      });
    }
  }

  /// ギャラリーを削除する
  Future<void> deleteGallery(GalleryData galleryData) async {
    if (realm.isClosed) {
      return;
    }

    realm.write(() {
      //プロンプトデータがあった場合
      if (galleryData.promptData != null) {
        //画像データをDBから削除
        realm.deleteMany(galleryData.promptData!.generatedImageList);

        //プロンプトデータをDBから削除
        realm.delete(galleryData.promptData!);
      }

      //ギャラリーデータを削除
      realm.delete(galleryData);
      //ストリームに削除後のデータを送る
      streamController.sink.add(realm.all<GalleryData>());
    });
  }

  /// ギャラリーに使用されているファイルを削除する
  Future<void> deleteGalleryFile(GalleryData galleryData) async {
    if (galleryData.promptData != null) {
      final imageList = galleryData.promptData!.generatedImageList;
      if (imageList.isNotEmpty) {
        //削除対象のディレクトリ
        Directory? deleteDir;
        for (var item in imageList) {
          try {
            final path = await DBUtil.getImageFullPath(item.imagePath);
            //削除対象のファイル
            final deleteFile = File(path!);
            if (await deleteFile.exists()) {
              /// 削除対象のディレクトリがnullだったら
              /// 削除対象のファイルの親ディレクトリを取得して入れる
              deleteDir ??= deleteFile.parent;
              await deleteFile.delete();
            }
          } catch (e) {}
        }

        if (deleteDir != null) {
          /// 削除対象ディレクトリに入っているファイル一覧
          /// このファイル一覧が空じゃない場合はまだ何かしらのファイルが残っているのでディレクトリを削除しない
          final chilList = await deleteDir.list(recursive: true).toList();

          // 子ファイルが無かったらディレクトリを削除する
          if (chilList.isEmpty) {
            await deleteDir.delete();
          }
        }
      }
    }
  }

  Future<void> deleteImageData(RealmList<ImageData> imageData) async {
    if (realm.isClosed) {
      return;
    }

    realm.write(() {
      realm.deleteMany(imageData);
    });
  }
}
