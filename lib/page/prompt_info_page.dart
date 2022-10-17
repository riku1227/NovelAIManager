import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novelai_manager/components/dialog/delete_alert_dialog.dart';
import 'package:novelai_manager/components/widget/outline_container.dart';
import 'package:novelai_manager/model/nai_base_model.dart';
import 'package:novelai_manager/model/nai_undesired_content.dart';
import 'package:novelai_manager/page/gallery_edit_page.dart';
import 'package:novelai_manager/repository/gallery_data_repository.dart';
import 'package:novelai_manager/util/db_util.dart';

import '../model/schema/gallery_schema.dart';

/// プロンプトの情報を表示するページ
class PromptInfoPage extends StatefulWidget {
  GalleryData galleryData;
  PromptInfoPage({super.key, required this.galleryData});

  /// Navigator用のRouteを取得する
  static MaterialPageRoute getRoute(GalleryData galleryData) {
    return MaterialPageRoute(
      builder: (context) {
        return PromptInfoPage(galleryData: galleryData);
      },
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _PromptInfoPageState();
  }
}

class _PromptInfoPageState extends State<PromptInfoPage> {
  //プロンプトのテキストフィールド用コントローラーのリスト
  final promptTextControllerList =
      List<TextEditingController>.empty(growable: true);
  //ネガティブプロンプトのテキストフィールド用コントローラー
  final negativePromptTextController = TextEditingController();
  //Stepsのテキストフィールド用コントローラー
  final stepsTextController = TextEditingController();
  //Scaleのテキストフィールド用コントローラー
  final scaleTextController = TextEditingController();
  //Seedのテキストフィールド用コントローラー
  final seedTextController = TextEditingController();
  //横幅解像度のテキストフィールド用コントローラー
  final imageWidthTextController = TextEditingController();
  //縦幅解像度のテキストフィールド用コントローラー
  final imageHeightTextController = TextEditingController();

  /// クリップボードにテキストをコピーする
  /// コピー後スナックバーでメッセージが表示される
  Future<void> copyToClipboard(BuildContext context, String copyText) async {
    /// 非同期処理した後にBuildContextを扱うとエラーを吐く
    /// なので処理前にBuildContextを使ってメッセンジャーを取得しておく
    final messenger = ScaffoldMessenger.of(context);
    final data = ClipboardData(text: copyText);
    await Clipboard.setData(data);

    messenger.showSnackBar(
      const SnackBar(
          duration: Duration(milliseconds: 800),
          content: Text("クリップボードにコピーしました")),
    );
  }

  /// ギャラリーデータを削除する
  Future<void> deleteGallery(
      BuildContext context, GalleryData galleryData) async {
    /// 非同期処理した後にコンテキスト扱うと怒られるので
    /// 非同期処理前にコンテキストを使ってナビゲーターを取得しておく
    final navigator = Navigator.of(context);
    final repository = await GalleryDataRepository.getInstance();
    //先に画像ファイルを削除
    await repository.deleteGalleryFile(galleryData);

    //ファイルを削除した後にデータベースからデータを削除
    await repository.deleteGallery(galleryData);
    //プロンプト情報ページを閉じて戻る
    navigator.pop();
  }

  /// プロンプトのデータが無かった場合に表示されるエラーウィジェット
  Widget buildErrorWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.galleryData.title),
      ),
      body: const Text("プロンプトのデータが存在しません"),
    );
  }

  /// 左側のUIを作成
  ///  | 登録されている画像のリスト
  Widget buildLeftAreaWidget(PromptData promptData) {
    return ListView.builder(
      itemCount: promptData.generatedImageList.length,
      itemBuilder: ((context, index) {
        return SizedBox(
          height: 512,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: OutlineContainer(
              child: FutureBuilder(
                //DBに保存されている相対パスから画像ファイルのフルパスを取得
                future: DBUtil.getImageFullPath(
                    promptData.generatedImageList[index].imagePath),
                builder: (context, snapshot) {
                  //データがまだ届いてない場合は読み込み中のテキストを出す
                  if (!snapshot.hasData) {
                    return const Text("読み込み中...");
                  } else {
                    /// データがエラーだったらエラー文をそのままテキストに出す
                    /// 正常に取得できた場合は画像を表示
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return Image.file(
                        File(snapshot.data!),
                      );
                    }
                  }
                },
              ),
            ),
          ),
        );
      }),
    );
  }

  /// プロンプトテキストフィールドのリストを作成
  Widget buildPromptListView(PromptData promptData) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: promptData.prompt.length,
      itemBuilder: ((context, index) {
        /// プロンプト用テキストコントローラーのリストの
        /// 現在のインデックスにデータが無かったら (インデックスが配列のサイズより大きかったら)
        /// テキストコントローラーを追加してそのコントローラーにプロンプトのテキストをセットする
        if (promptTextControllerList.length - 1 < index) {
          promptTextControllerList.add(TextEditingController());
          promptTextControllerList[index].text = promptData.prompt[index];
        }

        return Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  controller: promptTextControllerList[index],
                ),
              ),
              //コピーボタン
              IconButton(
                onPressed: () async {
                  /// クリップボードにコピー
                  await copyToClipboard(
                      context, promptTextControllerList[index].text);
                },
                icon: const Icon(Icons.copy),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// ネガティブプロンプトのテキストフィールドを作成
  Widget buildNegativePrompt(PromptData promptData) {
    //テキストコントローラーにネガティブプロンプトのテキストをセット
    negativePromptTextController.text = promptData.undesiredPrompt[0];

    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
            controller: negativePromptTextController,
          ),
        ),
        //コピーボタン
        IconButton(
          onPressed: () async {
            //クリップボードにコピーする
            await copyToClipboard(context, negativePromptTextController.text);
          },
          icon: const Icon(Icons.copy),
        ),
      ],
    );
  }

  /// シード値のテキストフィールドを作成
  Widget buildSeedTextField(PromptData promptData) {
    /// シード値のテキストコントローラーに値をセット
    /// doubleからtoStringすると
    /// nullの場合"null"
    /// それ以外の場合は".0"
    /// が付いてくるからそれを消す処理を入れる
    seedTextController.text =
        promptData.seed.toString().replaceAll("null", "").replaceAll(".0", "");
    return Row(
      children: [
        //-----テキストフィールド-----
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            maxLines: 1,
            controller: seedTextController,
          ),
        ),
        //-----コピーボタン-----
        IconButton(
          onPressed: () async {
            await copyToClipboard(context, seedTextController.text);
          },
          icon: const Icon(Icons.copy),
        ),
      ],
    );
  }

  /// 右側のUIの作成
  ///   | タイトルとかプロンプトとか
  Widget buildRightAreaWidget(GalleryData galleryData) {
    /// プロンプトデータがnullだった場合はここは呼び出されずに
    /// エラーウィジェットが表示されるので!でok
    final promptData = galleryData.promptData!;

    /// コード量を少なくするため用のテーマ変数
    final theme = Theme.of(context);

    stepsTextController.text = promptData.steps.toString();
    scaleTextController.text = promptData.scale.toString();
    imageWidthTextController.text = promptData.width.toString();
    imageHeightTextController.text = promptData.height.toString();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ****************************************
            /// ---------- ギャラリー情報カード ----------
            /// ****************************************
            ///   | タイトルとか説明とか
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                    ),
                    // タイトルテキスト
                    Text(
                      galleryData.title,
                      style: theme.textTheme.headline5,
                    ),
                    // 説明テキスト
                    Text(promptData.description),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            /// ****************************************
            /// ---------- 基本設定カード ----------
            /// ****************************************
            ///   | プロンプトとか使用モデルとか
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: double.infinity),
                    Text(
                      "基本設定",
                      style: theme.textTheme.headline5,
                    ),
                    //ベースモデルテキスト
                    Text(
                      "モデル: ${NAIBaseModel.getNameByValue(promptData.baseModel)}",
                      style: theme.textTheme.headline6,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "プロント",
                      style: theme.textTheme.subtitle1,
                    ),
                    buildPromptListView(promptData),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            /// ****************************************
            /// ---------- Model-Specific Settingsカード----------
            /// ****************************************
            ///   | Undesired Contentとかネガティブプロンプトとか
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: double.infinity),
                    Text(
                      "Model-Specific Settings",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(height: 8),

                    /// -----Undesired Contentテキスト-----
                    Row(
                      children: [
                        Text(
                          "Undesired Content:",
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(
                          "[ ${NAIUndesiredContent.getNameByValue(promptData.undesiredContent)} ]",
                          style: theme.textTheme.headline6,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    /// -----ネガティブプロンプト-----
                    Text(
                      "ネガティブ(Undesired Content)プロンプト",
                      style: theme.textTheme.subtitle1,
                    ),
                    buildNegativePrompt(promptData),
                    const SizedBox(height: 8),

                    ///-----クオリティタグ-----
                    CheckboxListTile(
                      title: const Text("クオリティタグを自動的に追加する"),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: promptData.addQualityTag,
                      onChanged: (value) {},
                    ),

                    //-----Steps, Scale, Seed-----
                    Row(
                      children: [
                        // ---Steps---
                        Expanded(
                          flex: 7,
                          child: Row(
                            children: [
                              const Text("Steps"),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: stepsTextController,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ---Scale---
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              const Text("Scale"),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: scaleTextController,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    //---Seed---
                    Text(
                      "Seed",
                      style: theme.textTheme.subtitle1,
                    ),
                    buildSeedTextField(promptData),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            /// ****************************************
            /// ---------- 画像設定----------
            /// ****************************************
            ///   | 解像度とか
            /// TODO
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: double.infinity),
                    Text(
                      "画像設定",
                      style: theme.textTheme.headline5,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        //-----横幅テキストフィールド-----
                        SizedBox(
                          width: 160,
                          child: TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "横幅",
                            ),
                            controller: imageWidthTextController,
                          ),
                        ),
                        //-----横幅コピーアイコンボタン-----
                        IconButton(
                          onPressed: () async {
                            await copyToClipboard(
                                context, imageWidthTextController.text);
                          },
                          icon: const Icon(Icons.copy),
                        ),

                        //---------------------
                        const SizedBox(width: 8),
                        const Text("X"),
                        const SizedBox(width: 8),
                        //---------------------

                        //-----縦幅テキストフィールド-----
                        SizedBox(
                          width: 160,
                          child: TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "縦幅",
                            ),
                            controller: imageHeightTextController,
                          ),
                        ),
                        //-----縦幅コピーアイコンボタン-----
                        IconButton(
                          onPressed: () async {
                            await copyToClipboard(
                                context, imageHeightTextController.text);
                          },
                          icon: const Icon(Icons.copy),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final promptData = widget.galleryData.promptData;
    if (promptData == null) {
      return buildErrorWidget();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.galleryData.title),
        actions: [
          //-----削除ボタン-----
          IconButton(
            onPressed: () async {
              /// 削除確認ダイアログを出す
              showDialog(
                  context: context,
                  builder: ((_) {
                    return const DeleteAlertDialog();
                  })).then((value) {
                // キャンセルもしくは外をタップしてダイアログを閉じたとき
                if (value == null) {
                  return;
                }
                //ギャラリーを削除する
                deleteGallery(context, widget.galleryData);
              });
            },
            icon: const Icon(Icons.delete),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  GalleryEditPage.getRoute(
                    galleryData: widget.galleryData,
                  )).then((value) {
                if (value != null) {
                  setState(() {
                    widget.galleryData = value;

                    /// プロンプトのテキストコントローラーを全て削除する
                    /// UIビルド時に自動生成されるため
                    promptTextControllerList.removeRange(
                        0, promptTextControllerList.length);
                  });
                }
              });
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: buildLeftAreaWidget(promptData),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: buildRightAreaWidget(widget.galleryData),
          ),
        ],
      ),
    );
  }
}
