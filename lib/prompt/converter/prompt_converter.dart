import 'dart:math';

import 'package:novelai_manager/prompt/converter/prompt_parse_data.dart';

/// NovelAIのウェブサイトと
/// Stable Diffusion web UI (AUTOMATIC1111)
/// のプロンプトを相互変換するクラス
/// アルゴリズムはこのコードそのまま使わせていただいています (感謝🙏)
/// https://github.com/naisd5ch/novel-ai-5ch-wiki-js/blob/main/src/prompt-table.js
class PromptConverter {
  ///Stable Diffusion web UI (AUTOMATIC1111)用のプロンプトをパースする
  static List<PromptParseData> parseWebUIPrompt(String srcPrompt) {
    //文字列を読み込んだ位置
    var index = 0;
    //パースしたプロンプトのデータリスト
    List<PromptParseData> promptParseDataList = [];

    /// 前回の位置
    /// 同じインデックスで無限ループになったことを検知するために使う
    var currentIndex = -1;

    while (index < srcPrompt.length) {
      //プロンプトの強度
      var power = 1.0;
      //プロンプトのテキスト部分
      var textPrompt = "";

      /// currentIndexと同じだったら処理を終わる
      if (currentIndex == index) {
        break;
      } else {
        currentIndex = index;
      }

      //空白をスキップする
      while (index < srcPrompt.length && srcPrompt[index] == " ") {
        index++;
      }

      /// 括弧だけの強度を取得する
      /// コロンで指定されてた場合は後で上書きする
      while (index < srcPrompt.length &&
          (srcPrompt[index] == "(" || srcPrompt[index] == "[")) {
        if (srcPrompt[index] == "(") {
          power *= 1.1;
        }
        if (srcPrompt[index] == "[") {
          power /= 1.1;
        }
        index++;
      }

      //記号が来るまでテキストプロンプトに追加していく
      while (index < srcPrompt.length &&
          (srcPrompt[index] != "(" &&
              srcPrompt[index] != ")" &&
              srcPrompt[index] != "[" &&
              srcPrompt[index] != "]" &&
              srcPrompt[index] != ":" &&
              srcPrompt[index] != ",")) {
        textPrompt += srcPrompt[index];
        index++;
      }

      if (index < srcPrompt.length && srcPrompt[index] == ":") {
        //コロンの次に行く
        index++;

        var powerText = "";
        //数値を読み込む
        while (index < srcPrompt.length &&
            RegExp(r'[\d.]').hasMatch(srcPrompt[index])) {
          powerText += srcPrompt[index];
          index++;
        }
        final parsePower = double.tryParse(powerText);
        if (parsePower != null) {
          power = parsePower;
        }
      }

      //最後に閉じる記号とかを読み飛ばす
      while (index < srcPrompt.length &&
          (srcPrompt[index] == ")" ||
              srcPrompt[index] == "]" ||
              srcPrompt[index] == " " ||
              srcPrompt[index] == ",")) {
        index++;
      }

      //パースしたプロンプトをリストに追加する
      promptParseDataList.add(PromptParseData(
        text: textPrompt,
        power: power,
      ));
    }

    return promptParseDataList;
  }

  ///NovelAIのウェブサイト用プロンプトをパースする
  static List<PromptParseData> parseNAIPrompt(String srcPrompt) {
    //文字列を読み込んだ位置
    var index = 0;
    //パースしたプロンプトのデータリスト
    List<PromptParseData> promptParseDataList = [];

    /// 前回の位置
    /// 同じインデックスで無限ループになったことを検知するために使う
    var currentIndex = -1;

    while (index < srcPrompt.length) {
      //プロンプトの強度
      var power = 1.0;
      //プロンプトのテキスト部分
      var textPrompt = "";

      /// currentIndexと同じだったら処理を終わる
      if (currentIndex == index) {
        break;
      } else {
        currentIndex = index;
      }

      //空白をスキップする
      while (index < srcPrompt.length && srcPrompt[index] == " ") {
        index++;
      }

      //強度を取得する
      while (index < srcPrompt.length &&
          (srcPrompt[index] == "{" || srcPrompt == "[")) {
        final currentChar = srcPrompt[index];
        index++;
        //{と{とかの間にある空白をスキップする
        if (currentChar == " ") {
          continue;
        }

        if (currentChar == "{") {
          power *= 1.05;
          continue;
        }

        if (currentChar == "[") {
          power /= 1.05;
          continue;
        }
        break;
      }

      //記号が来るまでテキストプロンプトに追加していく
      while (index < srcPrompt.length &&
          srcPrompt[index] != "{" &&
          srcPrompt[index] != "}" &&
          srcPrompt[index] != "[" &&
          srcPrompt[index] != "]" &&
          srcPrompt[index] != ",") {
        textPrompt += srcPrompt[index];
        index++;
      }

      //最後に閉じる記号とかを読み飛ばす
      while (index < srcPrompt.length &&
          (srcPrompt[index] == "}" ||
              srcPrompt[index] == "]" ||
              srcPrompt[index] == " " ||
              srcPrompt[index] == ",")) {
        index++;
      }

      promptParseDataList.add(PromptParseData(text: textPrompt, power: power));
    }

    return promptParseDataList;
  }

  /// パースされたプロンプトのデータをNovelAIのウェブサイト用にエンコードする
  static String encodeToNAIPrompt(List<PromptParseData> parseDataList) {
    List<String> promptList = [];
    var result = "";
    for (var item in parseDataList) {
      //プロンプトに強弱を付けていない場合はそのまま返す
      if (item.power == 1.0) {
        promptList.add(item.text);
      } else {
        //括弧を付ける数
        var powerCount = 0;
        while (true) {
          //長くなりすぎないように15で止める
          if (powerCount > 15) {
            break;
          }
          powerCount++;

          /// プロンプトの強度が1以下かつ
          /// プロンプトの強度が(1を1.05のn乗[n=powerCount])で割った数字以上の時 (プロンプトの強度より下回ってしまった時)
          if (item.power <= 1.0 && item.power > 1.0 / pow(1.05, powerCount)) {
            //カウントの追加を辞める
            break;
          }

          /// プロンプトの強度が1以上かつ
          /// プロンプトの強度が(1を1.05のn乗[n=powerCount])で掛けた数以下の時 (プロンプトの強度より上回ってしまったとき)
          else if (item.power >= 1.0 && item.power < pow(1.05, powerCount)) {
            //カウントの追加を辞める
            break;
          }
        }

        /// 括弧数を追加する時の比較が"超えたとき"なので
        /// この時点で既に括弧数が超えてしまっている
        /// その括弧数が超えた方が実際の値に近いのか、超えない方が実際の値に近いのかを比較して
        /// 近い方を採用する

        //括弧の数が1以上かつプロンプトの強度が1以下の時 ([]で弱体させるプロンプト)
        if (powerCount > 0 && item.power <= 1.0) {
          /// プロンプトの強度の誤差を、括弧の数が超えている方と超えていない方で比較
          /// 超えている方の誤差が超えていない方より大きかった場合は括弧の数を減らす
          if ((item.power - (1.0 / pow(1.05, powerCount))).abs() >
              (item.power - (1.0 / pow(1.05, powerCount - 1))).abs()) {
            powerCount--;
          }
        }
        //括弧の数が1以上かつプロンプトの強度が1以上の時 ({}で強調されるプロンプト)
        else if (powerCount > 0 && item.power >= 1.0) {
          /// プロンプトの強度の誤差を、括弧の数が超えている方と超えていない方で比較
          /// 超えている方の誤差が超えていない方より大きかった場合は括弧の数を減らす
          if ((item.power - pow(1.05, powerCount)) >
              (item.power - pow(1.05, powerCount - 1))) {
            powerCount--;
          }
        }

        //プロンプトリストに追加する
        if (item.power > 1.0) {
          promptList.add(("{" * powerCount) + item.text + ("}" * powerCount));
        } else {
          promptList.add(("[" * powerCount) + item.text + ("]" * powerCount));
        }
      }
    }

    //最後にプロンプトリストをリザルトの文字列に追加する
    for (var item in promptList) {
      if (result.isNotEmpty) {
        result += ",";
      }
      result += item;
    }

    return result;
  }

  /// パースされたプロンプトのデータをStable Diffusion web UI (AUTOMATIC1111)向けのプロンプト用にエンコードする
  static String encodeToWebUIPrompt(List<PromptParseData> parseDataList) {
    var result = "";

    for (var item in parseDataList) {
      if (result.isNotEmpty) {
        result += ",";
      }
      if (item.power == 1.0) {
        result += item.text;
      } else {
        result += "(${item.text}:${item.power})";
      }
    }

    return result;
  }
}
