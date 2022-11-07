import 'dart:convert';
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:novelai_manager/components/widget/copy_text_field.dart';
import 'package:novelai_manager/components/widget/my_scroll_view.dart';
import 'package:novelai_manager/components/widget/outline_container.dart';
import 'package:novelai_manager/prompt/image_metadata/metadata_type.dart';
import 'package:novelai_manager/prompt/image_metadata/png_metadata.dart';
import 'package:novelai_manager/util/general_util.dart';
import 'package:path/path.dart';

import '../components/dialog/prompt_convert_dialog.dart';
import '../model/json/nai_parameter.dart';

class PNGMetaDataViewerPage extends StatefulWidget {
  const PNGMetaDataViewerPage({super.key});

  /// Navigator用のRouteを取得する
  static MaterialPageRoute getRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return const PNGMetaDataViewerPage();
      },
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _PNGMetaDataViewerPageState();
  }
}

class _PNGMetaDataViewerPageState extends State<PNGMetaDataViewerPage> {
  // メタデータを見るPNGファイル
  File? pngFile;

  // 読み込んだメタデータ
  PNGMetaData? pngMetaData;

  //ファイル選択ダイアログで画像を選択する
  void pickImage() async {
    final filePaths = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["png"],
      allowMultiple: false,
    );
    if (filePaths == null) {
      return;
    }

    if (filePaths.isSinglePick) {
      pngFile = File(filePaths.files[0].path!);
      pngMetaData = await PNGMetaData.getPNGMetaData(pngFile!);
      setState(() {});
    }
  }

  /// 画像をドラッグアンドドロップした時
  void onImageDragDone(DropDoneDetails details) async {
    //ファイルのリストが空だったら処理を辞める
    if (details.files.isEmpty) {
      return;
    }

    //一応ファイルが存在しているかチェックする
    if (!File(details.files[0].path).existsSync()) {
      return;
    }

    // PNGファイルしか受け付けない
    if (extension(details.files[0].path) == ".png") {
      pngFile = File(details.files[0].path);
      pngMetaData = await PNGMetaData.getPNGMetaData(pngFile!);
      setState(() {});
    }
  }

  /// 画像を選択する部分
  /// ドラッグアンドドロップで画像を放り込むことも可能
  Widget buildImageDropTarget() {
    return DropTarget(
      onDragDone: (details) => onImageDragDone(details),
      child: OutlineContainer(
        child: SizedBox(
          height: 440,
          width: 440,
          child: pngFile != null
              ?
              //画像が存在する場合
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Center(
                        child: Image.file(pngFile!),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: ElevatedButton(
                          child: const Icon(Icons.remove_circle),
                          onPressed: () {
                            pngFile = null;
                            pngMetaData = null;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                )
              :
              //画像が存在しない場合
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: "D&Dで画像を読み込むこともできます",
                      child: OutlinedButton(
                        onPressed: () {
                          pickImage();
                        },
                        child: const Text("画像を選択する"),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget buildImageInformation(BuildContext context) {
    if (pngFile == null) {
      return Column();
    }

    final theme = Theme.of(context);

    var metaDataType = "";
    switch (pngMetaData!.metaDataType) {
      case MetaDataType.NOVELAI:
        metaDataType = "Novel AI";
        break;
      case MetaDataType.STABLE_DIFFUSION_WEBUI:
        metaDataType = "Stable Diffusion web UI";
        break;
      case MetaDataType.OTHER:
        metaDataType = "その他";
        break;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            Text(
              "画像情報",
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "解像度 (横 x 縦)",
              style: theme.textTheme.caption,
            ),
            SelectableText(
              "${pngMetaData!.width} x ${pngMetaData!.height}",
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              "メタデータタイプ",
              style: theme.textTheme.caption,
            ),
            SelectableText(
              metaDataType,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              "ファイルパス",
              style: theme.textTheme.caption,
            ),
            SelectableText(
              pngFile!.path,
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  /// メタデータのrawデータを表示する
  Widget buildRawMetaData() {
    if (pngMetaData!.metaDataType != MetaDataType.NOVELAI) {
      return Column();
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Raw"),
          OutlineContainer(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SelectableText("""title: ${pngMetaData!.title}

description: ${pngMetaData!.description}

comment: ${pngMetaData!.comment}

source: ${pngMetaData!.source}"""),
            ),
          ),
        ],
      ),
    );
  }

  /// ----- 左側のUI -----
  Widget buildLeftArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          buildImageDropTarget(),
          const SizedBox(height: 16),
          //----- 画像情報カード -----
          buildImageInformation(context),
          //----- rawデータ -----
          buildRawMetaData(),
        ],
      ),
    );
  }

  // NovelAI方式のメタデータ情報を表示する
  Widget buildNAIMetaData(BuildContext context) {
    final naiParameter =
        NAIParameter.fromJson(json.decode(pngMetaData!.comment));

    //プロンプト
    final promptTextController = TextEditingController();
    promptTextController.text = pngMetaData!.description;

    //ネガティブプロンプト
    final negativePromptTextController = TextEditingController();
    negativePromptTextController.text = naiParameter.uc;

    //シード値
    final seedTextController = TextEditingController();
    seedTextController.text = naiParameter.seed.toString().replaceAll(".0", "");

    //ステップ数
    final stepsTextController = TextEditingController();
    stepsTextController.text = naiParameter.steps.toString();

    //スケール
    final scaleTextController = TextEditingController();
    scaleTextController.text =
        naiParameter.scale.toString().replaceAll(".0", "");

    //ストレンジ
    final strengthTextController = TextEditingController();
    strengthTextController.text =
        naiParameter.strength.toString().replaceAll(".0", "");

    //ノイズ
    final noiseTextController = TextEditingController();
    noiseTextController.text =
        naiParameter.noise.toString().replaceAll(".0", "");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: double.infinity,
        ),
        //----- プロンプトテキストフィールド -----
        const Text("プロンプト"),
        const SizedBox(height: 12),
        CopyTextField(
          textField: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "プロンプト",
            ),
            maxLines: 3,
            controller: promptTextController,
          ),
          onLongPress: (text) async {
            //変換ダイアログを表示して結果を取得
            final convertResult = await showDialog(
                context: context,
                builder: (_) => PromptConvertDialog(
                      prompt: text,
                    ));
            //結果がnullじゃなかったら
            if (convertResult != null) {
              if (!mounted) {
                return;
              }
              await GeneralUtil.copyToClipboard(context, convertResult);
            }
          },
        ),
        const SizedBox(height: 16),
        //----- ネガティブプロンプトテキストフィールド -----
        const Text("ネガティブプロンプト"),
        const SizedBox(height: 12),
        CopyTextField(
          textField: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "ネガティブプロンプト",
            ),
            maxLines: 3,
            controller: negativePromptTextController,
          ),
          onLongPress: (text) async {
            //変換ダイアログを表示して結果を取得
            final convertResult = await showDialog(
                context: context,
                builder: (_) => PromptConvertDialog(
                      prompt: text,
                    ));
            //結果がnullじゃなかったら
            if (convertResult != null) {
              if (!mounted) {
                return;
              }
              await GeneralUtil.copyToClipboard(context, convertResult);
            }
          },
        ),
        const SizedBox(height: 18),
        //----- シード値テキストフィールド -----
        const Text("シード値"),
        const SizedBox(height: 12),
        CopyTextField(
          textField: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Seed",
            ),
            controller: seedTextController,
          ),
        ),
        const SizedBox(height: 16),
        //----- ステップ数/スケール テキストフィールド -----
        const Text("ステップ数 / スケール"),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CopyTextField(
                textField: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Steps",
                  ),
                  controller: stepsTextController,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CopyTextField(
                textField: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Scale",
                  ),
                  controller: scaleTextController,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),
        //----- Strength/Noise テキストフィールド -----
        const Text("Strength / Noise"),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CopyTextField(
                textField: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Strength",
                  ),
                  controller: strengthTextController,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CopyTextField(
                textField: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Noise",
                  ),
                  controller: noiseTextController,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sampler",
                  style: Theme.of(context).textTheme.caption,
                ),
                SelectableText(
                  naiParameter.sampler,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "モデル",
                  style: Theme.of(context).textTheme.caption,
                ),
                SelectableText(
                  pngMetaData!.source,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// ----- 右側のUI -----
  Widget buildRightArea(BuildContext context) {
    if (pngMetaData == null) {
      return Column();
    } else if (!pngMetaData!.isPNG) {
      return const Text("正常なPNGファイルではありません");
    } else if (pngMetaData!.metaDataType == MetaDataType.OTHER) {
      return const Text("メタデータが存在しないか、サポートしていない方式です");
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: MyScrollView(
        child: pngMetaData!.metaDataType == MetaDataType.NOVELAI
            ? buildNAIMetaData(context)
            : const Text("サポートされていない形式のメタデータです"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PNG MetaData Viewer"),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: MyScrollView(
              child: buildLeftArea(context),
            ),
          ),
          Expanded(
            flex: 5,
            child: buildRightArea(context),
          ),
        ],
      ),
    );
  }
}
