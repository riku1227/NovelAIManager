import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:novelai_manager/prompt/image_metadata/metadata_type.dart';
import 'package:novelai_manager/util/hex_util.dart';

/// PNGからプロンプトなどのメタデータを取得するクラス
class PNGMetaData {
  //画像がpngかどうか
  bool isPNG = false;

  /// 横幅
  int width = 0;

  /// 縦幅
  int height = 0;

  /// メタデータの種類
  /// NovelAIとStable Diffusion web UIで埋め込む情報が違う
  MetaDataType metaDataType = MetaDataType.OTHER;

  /// タイトル (NovelAI専用)
  ///   | - 「AI generated image」が入っている
  String title = "";

  /// 説明 (NovelAI専用)
  ///   | - プロンプトのデータが入っている
  ///   | - ネガティブプロンプトなどの他のデータは別の場所に入っている
  String description = "";

  /// コメント (NovelAI専用)
  ///   | - ステップ数やシード値、ネガティブプロンプトなどの情報がJson形式で入っている
  String comment = "";

  /// ソース (NovelAI専用)
  ///   | - 生成に使用したモデルの情報 「Stable Diffusion 81274D13」など
  String source = "";

  /// パラメーター (Stable Diffusion web UI専用)
  ///   | - プロンプトやステップ数、シード値、ネガティブプロンプトなどのデータが独自形式で入っている
  String parameters = "";

  /// チャンクデータのマップ
  Map<String, Uint8List> chunkData = {};

  /// コンストラクタ
  PNGMetaData({required Uint8List data}) {
    isPNG = _isPNG(data);
    if (!isPNG) {
      return;
    }

    //PNGのチャンクデータをパースする
    chunkData = _parseChunkData(data);

    //解像度
    if (chunkData.containsKey("IHDR")) {
      width = HexUtil.convertToDecimalNumber(
          Uint8List.fromList(chunkData["IHDR"]!.getRange(0, 4).toList()));
      height = HexUtil.convertToDecimalNumber(
          Uint8List.fromList(chunkData["IHDR"]!.getRange(4, 8).toList()));
    }

    //タイトル
    if (chunkData.containsKey("tEXtTitle")) {
      title = latin1.decode(chunkData["tEXtTitle"]!);
    }

    //説明 (NovelAIのプロンプト)
    if (chunkData.containsKey("tEXtDescription")) {
      description = latin1.decode(chunkData["tEXtDescription"]!);
    }
    //説明 (NovelAIのプロンプト)のマルチバイト文字版
    if (chunkData.containsKey("iTXtDescription")) {
      description = utf8.decode(chunkData["iTXtDescription"]!.toList());
    }

    //コメント (NovelAIのパラメーター)
    if (chunkData.containsKey("tEXtComment")) {
      comment = latin1.decode(chunkData["tEXtComment"]!);
    }
    //コメント (NovelAIのパラメーター)のマルチバイト文字版
    if (chunkData.containsKey("iTXtComment")) {
      comment = utf8.decode(chunkData["iTXtComment"]!.toList());
    }

    //パラメーター (Stable Diffusion web UIのパラメーター)
    if (chunkData.containsKey("tEXtparameters")) {
      parameters = latin1.decode(chunkData["tEXtparameters"]!);
    }
    //パラメーター (Stable Diffusion web UIのパラメーター)のマルチバイト文字版
    if (chunkData.containsKey("iTXtparameters")) {
      parameters = utf8.decode(chunkData["iTXtparameters"]!);
    }

    //ソース (NovelAIのパラメーター)
    if (chunkData.containsKey("tEXtSource")) {
      source = latin1.decode(chunkData["tEXtSource"]!);
    }

    //メタデータの種類を判別
    if (chunkData.containsKey("tEXtSoftware")) {
      if (latin1.decode(chunkData["tEXtSoftware"]!) == "NovelAI") {
        metaDataType = MetaDataType.NOVELAI;
      }
    } else if (parameters.isNotEmpty) {
      metaDataType = MetaDataType.STABLE_DIFFUSION_WEBUI;
    }
  }

  /// FileからPNGMetaDataを取得する
  static Future<PNGMetaData> getPNGMetaData(File file) async {
    final pngData = await file.readAsBytes();
    return PNGMetaData(data: pngData);
  }

  /// 読み込んだファイルがpngかどうか
  /// 先頭4バイトで判別 (8バイトで判別するべきかもしれないけどまあ...)
  bool _isPNG(Uint8List data) {
    if (data[0] == 0x89 &&
        data[1] == 0x50 &&
        data[2] == 0x4E &&
        data[3] == 0x47) {
      return true;
    } else {
      return false;
    }
  }

  /// チャンクデータをパースする
  /// <チャンク名, データ>のMapを返す
  Map<String, Uint8List> _parseChunkData(Uint8List data) {
    var result = <String, Uint8List>{};

    //先頭のpngシグネチャをスキップ
    var offset = 8;

    //isEndをtrueにするとwhileが終わる
    var isEnd = false;
    while (!isEnd) {
      /// PNGのチャンクデータ
      /// データの長さ : 4byte
      ///   | - チャンク名以降にあるチャンクのデータ
      /// チャンク名 : 4byte
      ///   | - チャンクの名前
      /// チャンクデータ : 可変 (データの長さで取得できる)
      ///   | - チャンクのデータ
      ///   | - プロンプトとか入る
      /// CRC : 4byte
      ///   | - プロンプト情報とかが取れたら良いのでここは無視
      ///

      //データの長さを取得する
      final chunkLength =
          HexUtil.convertToDecimalNumber(data.buffer.asUint8List(offset, 4));
      //その分位置を進める
      offset += 4;

      //チャンクの名前を取得する
      var chunkName = String.fromCharCodes(data.buffer.asUint8List(offset, 4));
      //その分進める
      offset += 4;

      //チャンクのデータを取得する
      final chunkData = data.buffer.asUint8List(offset, chunkLength);

      /// tEXtは直後に"Title"とか"Description"とかのキーワードが入るから
      /// tEXt + キーワード をチャンク名として処理する
      /// そのため分岐でそれ用の処理をする
      if (chunkName == "tEXt") {
        /// キーワードとデータの間には"0x00"が入っているのでそこでそこで分割することで
        /// 別々にすることが出来る
        chunkName +=
            String.fromCharCodes(chunkData.sublist(0, chunkData.indexOf(0x00)));
        result[chunkName] = chunkData.sublist(chunkData.indexOf(0x00) + 1);
      }

      /// iTXtはマルチバイト文字が含まれている場合に使用される
      /// tEXtと違いキーワードと内容の間にいくつかのフラグが含まれている
      /// 現状 Novel AI / Stable Diffusion web UI共に特にこのフラグは使用されていなさそうなので
      /// フラグのバイト分(+4)進めて内容を取得する
      else if (chunkName == "iTXt") {
        /// キーワードとデータの間には"0x00"が入っているのでそこでそこで分割することで
        /// 別々にすることが出来る
        chunkName +=
            String.fromCharCodes(chunkData.sublist(0, chunkData.indexOf(0x00)));

        /// フラグ分4進める
        result[chunkName] = chunkData.sublist(chunkData.indexOf(0x00) + 1 + 4);
      } else {
        //tEXt以外のデータはそのまま突っ込む
        result[chunkName] = chunkData;
      }
      //読み込んだデータ分進める
      offset += chunkLength;

      //CRCは読み飛ばす
      offset += 4;

      if (chunkName == "IEND") {
        isEnd = true;
      }
    }

    return result;
  }
}
