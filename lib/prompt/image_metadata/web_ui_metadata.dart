/// Stable Diffusion web UI方式のメタデータクラス
class WebUIMetaData {
  // 読み込んだメタデータがWebUIかどうか
  bool isWebUIMetaData = false;

  // プロンプト
  String prompt = "";

  // ネガティブプロンプト
  String negativePrompt = "";

  //ステップ数
  int steps = 0;

  //サンプラー
  String sampler = "";

  //スケール
  double scale = 0.0;

  //シード値
  double seed = -1;

  //モデルハッシュ
  String modelHash = "";

  //Denoising strength
  double denoisingStrength = 0.0;

  //Clip skip
  int clipSkip = 0;

  //ENSD
  int ensd = 0;

  WebUIMetaData(String metaDataText) {
    final lineSplit = metaDataText.split('\n');

    /// メタデータの行数が3行未満だったら
    /// WebUIのメタデータでは無い画像判定
    ///   | - WebUIは 1行目にプロンプト、2行目にネガティブプロンプト、3行目のその他のパラメーターを入れる
    ///   | - ただしプロンプトやネガティブプロンプトが改行されていたらずれる
    if (lineSplit.length < 3) {
      isWebUIMetaData = false;
      return;
    }

    /// 現在のモード
    /// プロンプトなどが複数行の可能性もあるため
    /// 0 - プロンプトモード
    /// 1 - ネガティブプロンプトモード
    /// 3 - パラメーターモード
    int mode = 0;
    for (var item in lineSplit) {
      // 「Negative prompt: 」
      if (item.startsWith("Negative prompt: ")) {
        mode = 1;
        item = item.replaceAll("Negative prompt: ", "");
      } else if (item.contains("Steps: ") &&
          item.contains("Sampler: ") &&
          item.contains("Seed: ")) {
        mode = 2;
      }

      switch (mode) {
        // プロンプトモード
        case 0:
          prompt += item;
          break;
        // ネガティブプロンプトモード
        case 1:
          negativePrompt += item;
          break;
        // パラメーターモード
        case 2:
          //各パラメーターは「, 」で区切られている
          final splitParameter = item.split(", ");
          //分けたパラメーターを良い感じに入れるマップ
          final parameterMap = <String, String>{};

          /// パラメーターは「名前: 値」という形式なので、それで分け
          /// 名前をマップのキーにして値を入れる
          for (var parameter in splitParameter) {
            final split = parameter.split(": ");
            //コロンで分けた配列の長さが2未満だったら処理をスキップする
            if (split.length < 2) {
              continue;
            }
            parameterMap[split[0]] = split[1];
          }

          //ステップ数
          if (parameterMap.containsKey("Steps")) {
            final tryParse = int.tryParse(parameterMap["Steps"]!);
            steps = tryParse ?? steps;
          }

          //サンプラー
          if (parameterMap.containsKey("Sampler")) {
            sampler = parameterMap["Sampler"]!;
          }

          //スケール
          if (parameterMap.containsKey("CFG scale")) {
            final tryParse = double.tryParse(parameterMap["CFG scale"]!);
            scale = tryParse ?? scale;
          }

          //シード値
          if (parameterMap.containsKey("Seed")) {
            final tryParse = double.tryParse(parameterMap["Seed"]!);
            seed = tryParse ?? seed;
          }

          //モデルハッシュ
          if (parameterMap.containsKey("Model hash")) {
            modelHash = parameterMap["Model hash"]!;
          }

          //Denoising strength
          if (parameterMap.containsKey("Denoising strength")) {
            final tryParse =
                double.tryParse(parameterMap["Denoising strength"]!);
            denoisingStrength = tryParse ?? denoisingStrength;
          }

          //Clip skip
          if (parameterMap.containsKey("Clip skip")) {
            final tryParse = int.tryParse(parameterMap["Clip skip"]!);
            clipSkip = tryParse ?? clipSkip;
          }

          //ENSD
          if (parameterMap.containsKey("ENSD")) {
            final tryParse = int.tryParse(parameterMap["ENSD"]!);
            ensd = tryParse ?? ensd;
          }

          print(parameterMap);

          break;
      }
    }
    //print(lineSplit[4]);
  }
}
