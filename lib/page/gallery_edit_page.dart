import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novelai_manager/components/base_model_dropdown.dart';
import 'package:novelai_manager/components/dialog/simple_alert_dialog.dart';
import 'package:novelai_manager/components/widget/my_scroll_view.dart';
import 'package:novelai_manager/components/widget/outline_container.dart';
import 'package:novelai_manager/repository/gallery_data_repository.dart';
import 'package:novelai_manager/util/db_util.dart';
import 'package:novelai_manager/util/gallery_data_util.dart';
import 'package:novelai_manager/util/io_util.dart';
import 'package:path/path.dart';
import 'package:realm/realm.dart';

import '../components/undesired_content_dropdown.dart';
import '../model/schema/gallery_schema.dart';

/// ギャラリーデータを編集するページ
/// 新規作成 / 既存データ編集 兼用
class GalleryEditPage extends StatefulWidget {
  /// 既存データを編集する場合はギャラリーデータを引数に渡す
  /// データを渡さなかった場合は新規作成になる
  GalleryData? galleryData;

  GalleryEditPage({super.key, this.galleryData});

  /// Navigator用のRouteを取得する
  static MaterialPageRoute getRoute({GalleryData? galleryData}) {
    return MaterialPageRoute(
      builder: (context) {
        return GalleryEditPage(galleryData: galleryData);
      },
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _GalleryEditPage();
  }
}

class _GalleryEditPage extends State<GalleryEditPage> {
  late GalleryData galleryData;

  /// 登録する画像のファイルパスが入るリスト
  /// 保存するときにそこからデータベースフォルダにコピーして、ギャラリーデータにはそこのパスを入れる
  final List<String> imageFilePathList = [];

  /// ギャラリータイトルのテキストコントローラー
  final galleryTitleTextController = TextEditingController();

  /// プロンプト説明のテキストコントローラー
  final promptDescriptionTextController = TextEditingController();

  /// プロンプトテキストのテキストコントローラーリスト
  final List<TextEditingController> promptTextControllerList = [];

  /// ネガティブプロンプトのテキストコントローラー
  final negativePromptTextController = TextEditingController();

  /// ステップのテキストコントローラー
  final stepsTextController = TextEditingController();

  /// スケールのテキストコントローラー
  final scaleTextController = TextEditingController();

  /// シード値のテキストコントローラー
  final seedTextController = TextEditingController();

  /// 画像の横解像度のテキストコントローラー
  final imageWidthTextController = TextEditingController();

  /// 画像の縦解像度のテキストコントローラー
  final imageHeightTextController = TextEditingController();

  /// コピー前の画像データリスト
  /// DBへの二重登録問題への対処用
  /// ギャラリーデータのセーブ時には別の配列"imageFilePathList"を使って画像を登録する
  /// そうすると既存データ編集時、既に登録されている画像でも再度登録されてしまうので
  /// 既に登録されているデータを一度全て削除することで対処
  /// コピー後のデータだと別オブジェクトとなってしまい、削除できないのでコピー前のオリジナルデータを保存しておく
  RealmList<ImageData>? originalImageDataList;

  /// 入力欄に変更があったかの確認フラグ
  /// 変更があった場合は画面遷移時に警告を表示するために保持
  bool isEditDirty = false;

  @override
  void initState() {
    if (widget.galleryData != null) {
      //コピー前の画像データを保存しておく
      originalImageDataList =
          widget.galleryData!.promptData!.generatedImageList;

      /// 受け取ったギャラリーデータをコピーして入れる
      /// コピーしないと不正なデータベース操作関連のエラーが出て扱いにくい
      galleryData = GalleryDataUtil.copyGalleryData(widget.galleryData!);
    } else {
      /// プロンプトデータとギャラリーデータを新規で生成する
      ///  | プロンプトとネガティブプロンプトには初期データとして空文字を追加しておく
      final prompData = PromptData(Uuid.v4())
        ..undesiredPrompt.add("")
        ..prompt.add("");
      galleryData = GalleryData(
        Uuid.v4(),
        "",
        DateTime.now(),
        DateTime.now(),
      )..promptData = prompData;
    }

    final promptData = galleryData.promptData!;

    /// 画像のファイルパスリストに生成画像のパスを追加する
    ///  | 既存データ編集用
    for (var item in promptData.generatedImageList) {
      imageFilePathList.add(item.imagePath);
    }

    /// テキストコントローラーに値をセットしていく
    galleryTitleTextController.text = galleryData.title;
    promptDescriptionTextController.text = promptData.description;
    negativePromptTextController.text = promptData.undesiredPrompt[0];
    stepsTextController.text = promptData.steps.toString();
    scaleTextController.text = promptData.scale.toString();
    seedTextController.text =
        promptData.seed.toString().replaceAll("null", "").replaceAll(".0", "");
    imageWidthTextController.text = promptData.width.toString();
    imageHeightTextController.text = promptData.height.toString();

    super.initState();
  }

  /// 画像をリストに追加する
  /// 既に追加されている場合はスナックバーを出す
  void addImageFilePath(String filePath, BuildContext context) {
    if (imageFilePathList.contains(filePath)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 1200),
          content: Text("追加しようとした画像は既に登録されています"),
        ),
      );
    } else {
      imageFilePathList.add(filePath);
    }
  }

  /// 画像ファイルを選択する
  void pickImage(BuildContext context) async {
    final filePaths = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (filePaths == null) {
      return;
    }

    for (var item in filePaths.paths) {
      if (item != null) {
        setState(() {
          addImageFilePath(item, context);
        });
      }
    }
  }

  /// 登録された画像をデータベースに登録する
  Future<void> copyImageFileToDB() async {
    final promptData = galleryData.promptData!;

    // 既存データの画像リストを一端リセットする
    if (promptData.generatedImageList.isNotEmpty) {
      final repository = await GalleryDataRepository.getInstance();
      //データベースからも一度削除する
      repository.deleteImageData(originalImageDataList!);
      promptData.generatedImageList
          .removeRange(0, promptData.generatedImageList.length);
    }

    //使えない文字をエスケープする
    final escapeTitle = IOUtil.escapeString(galleryData.title);
    //データベースの画像を保存するフォルダ
    final imgDir = await DBUtil.getDataBaseImgFolder();
    //コピー先のフォルダ
    final copyDir = Directory("${imgDir.path}/$escapeTitle");
    if (!await copyDir.exists()) {
      await copyDir.create();
    }

    for (var item in imageFilePathList) {
      final path = await DBUtil.getImageFullPath(item);
      //コピー元のファイル
      final originalFile = File(path!);
      //コピー先のファイルパス
      final copyPath = "${copyDir.path}/${basename(originalFile.path)}";

      /// コピー先のファイルパスをDBに登録
      /// 実行ファイルがあるフォルダからの相対パスを登録する
      promptData.generatedImageList.add(
        ImageData(Uuid.v4(), "$escapeTitle/${basename(originalFile.path)}"),
      );

      final copyFile = File(copyPath);
      // コピー元とコピー先が同じだと何もしない
      if (copyFile.path == originalFile.path) {
        continue;
      }
      await originalFile.copy(copyPath);
    }
  }

  /// ギャラリーデータを保存する
  Future<void> saveGallery(BuildContext context) async {
    /// 非同期処理した後のコンテキストだとエラー出すので
    /// 処理前に先に作っておく
    final navigator = Navigator.of(context);

    //画像をDBにコピー
    await copyImageFileToDB();

    if (widget.galleryData == null) {
      galleryData.createdAt = DateTime.now();
    }
    galleryData.updatedAt = DateTime.now();

    final repository = await GalleryDataRepository.getInstance();
    await repository.addGallery(galleryData);
    navigator.pop(galleryData);
  }

  /// 画像一覧を作成する
  /// アウトラインで囲まれた画像の横並びリスト
  Widget buildAddImageList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      //ファイルをD&Dできるようにするウィジェット
      child: DropTarget(
        onDragDone: (details) {
          for (var item in details.files) {
            ///画像ファイル(png, jpg)だったら追加する
            if (extension(item.path) == ".png" ||
                extension(item.path) == ".jpg") {
              addImageFilePath(item.path, context);
              isEditDirty = true;
            }

            /// 追加するたびに更新するよりは最後にまとめて更新した方が多分良い
            setState(() {});
          }
        },
        child: OutlineContainer(
          child: SizedBox(
            height: 320,
            child: ReorderableListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageFilePathList.length,
              onReorder: (int oldIndex, int newIndex) {
                if (oldIndex < newIndex) {
                  /// oldIndexの要素を削除する前の段階でのnewIndexなので(?)
                  /// oldIndexから消した後に処理する場合1ずれる
                  /// 例: 0番目の要素を3番目に持ってきた場合、newIndexは"3"になる
                  ///   | まず0番目の要素を削除してから追加し直すのでindexが1ずれる(少なくなる)
                  newIndex--;
                }
                //まず配列から削除する
                final path = imageFilePathList.removeAt(oldIndex);

                setState(() {
                  //削除した要素をnewIndexの場所に追加する
                  imageFilePathList.insert(newIndex, path);
                });
                isEditDirty = true;
              },
              itemBuilder: (context, index) {
                return Padding(
                  key: Key("image_${imageFilePathList[index]}"),
                  padding: const EdgeInsets.all(8),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      //-----画像-----
                      FutureBuilder(
                        future:
                            DBUtil.getImageFullPath(imageFilePathList[index]),
                        builder: (context, snapshot) {
                          /// データが届いているかどうか
                          if (snapshot.hasData) {
                            return Image.file(File(snapshot.data!));
                          } else {
                            /// データが届いていない場合は読み込み中テキストを表示する
                            return const Text("読み込み中...");
                          }
                        },
                      ),
                      //-----削除ボタン-----
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: ElevatedButton(
                          child: const Icon(Icons.remove_circle),
                          onPressed: () {
                            /// 画像ファイルパスリストから削除してUIを更新する
                            setState(() {
                              imageFilePathList.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// プロントテキストフィールドのリストを作成する
  Widget buildPromptTextFieldList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: galleryData.promptData!.prompt.length,
      itemBuilder: (context, index) {
        /// 現在のインデックスよりテキストコントローラーのリストが小さかったら
        /// 追加してテキストをセットする
        if (promptTextControllerList.length - 1 < index) {
          promptTextControllerList.add(TextEditingController());
          promptTextControllerList[index].text =
              galleryData.promptData!.prompt[index];
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
                  onChanged: (value) {
                    galleryData.promptData!.prompt[index] = value;
                    isEditDirty = true;
                  },
                ),
              ),
              //----- プロンプト削除ボタン -----
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  galleryData.promptData!.prompt.removeAt(index);
                  promptTextControllerList.removeAt(index);
                  //プロンプトを削除してUIを更新する
                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Steps, Scape, Seedのテキストフィールドを作成
  Widget buildSpecificSettingsTextField() {
    return Row(
      children: [
        //-----Stepsテキストフィールド-----
        Expanded(
          flex: 2,
          child: TextField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Steps",
              counterText: "",
            ),
            controller: stepsTextController,
            onChanged: (value) {
              final parse = int.tryParse(value);
              if (parse != null) {
                galleryData.promptData!.steps = parse;
              }
              isEditDirty = true;
            },
          ),
        ),
        const SizedBox(width: 16),
        //-----Scaleテキストフィールド-----
        Expanded(
          flex: 1,
          child: TextField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Scale",
              counterText: "",
            ),
            controller: scaleTextController,
            onChanged: (value) {
              final parse = int.tryParse(value);
              if (parse != null) {
                galleryData.promptData!.scale = parse;
              }
              isEditDirty = true;
            },
          ),
        ),
        const SizedBox(width: 16),
        //-----Seedテキストフィールド-----
        Expanded(
          flex: 7,
          child: TextField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Seed",
              counterText: "",
            ),
            controller: seedTextController,
            onChanged: (value) {
              final parse = double.tryParse(value);
              if (parse != null) {
                galleryData.promptData!.seed = parse;
              }
              isEditDirty = true;
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final promptData = galleryData.promptData!;
    return WillPopScope(
        onWillPop: () async {
          //どこかしらのデータが編集されていたら確認ダイアログを表示する
          if (isEditDirty) {
            bool? isConfirmed = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return SimpleAlertDialog(
                  title: const Text("データが編集されています"),
                  content: const Text("未保存の項目は破棄されます\nそれでもページを閉じますか？"),
                  positiveButtonText: "閉じる",
                );
              },
            );

            /// SimpleAlertDialogはキャンセルした場合nullを返すので
            /// データがあった時点でポジティブボタンを押したことになる
            if (isConfirmed != null) {
              return true;
            } else {
              return false;
            }
          } else {
            //データを編集してない場合は普通に戻る
            return true;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("ギャラリーを編集"),
            actions: [
              //-----コピーボタン-----
              IconButton(
                onPressed: () async {
                  /// タイトルが入力されていない場合はエラースナックバーを出す
                  if (galleryData.title.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("タイトルが入力されていません"),
                      duration: Duration(milliseconds: 850),
                    ));
                    return;
                  }

                  /// 空白から始まるタイトルの場合はエラースナックバーを出す
                  if (galleryData.title[0] == " " ||
                      galleryData.title[0] == "　") {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("空白から始まるタイトルは設定できません"),
                      duration: Duration(milliseconds: 1200),
                    ));
                    return;
                  }
                  await saveGallery(context);
                },
                icon: const Icon(Icons.save),
              ),
            ],
          ),
          body: MyScrollView(
            child: Column(
              children: [
                /// ****************************************
                /// ---------- 画像リスト ----------
                /// ****************************************
                //-----画像リスト-----
                buildAddImageList(context),
                //-----画像追加ボタン-----
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.photo),
                        label: const Text("画像を追加する"),
                        onPressed: () {
                          pickImage(context);
                        },
                      ),
                    ),
                  ],
                ),

                //-----画像一覧と基本設定の仕切り-----
                const Padding(
                  padding: EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  child: Divider(
                    height: 32,
                  ),
                ),

                /// ****************************************
                /// ---------- プロンプトカード ----------
                /// ****************************************
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: double.infinity),
                        Text(
                          "基本設定",
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        //-----タイトルテキストフィールド-----
                        TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "タイトル",
                          ),
                          maxLines: 1,
                          controller: galleryTitleTextController,
                          onChanged: (value) {
                            galleryData.title = value;
                            isEditDirty = true;
                          },
                        ),
                        const SizedBox(height: 8),
                        //-----説明テキストフィールド-----
                        TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "説明",
                          ),
                          minLines: 2,
                          maxLines: 3,
                          controller: promptDescriptionTextController,
                          onChanged: (value) {
                            promptData.description = value;
                            isEditDirty = true;
                          },
                        ),
                        const SizedBox(height: 16),
                        //-----ベースモデルドロップダウン-----
                        const Text("モデル"),
                        BaseModelDropdown(
                          nowValue: promptData.baseModel,
                          onChanged: (value) {
                            promptData.baseModel = value;
                            isEditDirty = true;
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text("プロンプト"),
                        buildPromptTextFieldList(),
                        const SizedBox(height: 8),
                        //-----プロンプト追加ボタン-----
                        OutlinedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text("プロンプトを追加する"),
                          onPressed: () {
                            setState(() {
                              promptData.prompt.add("");
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                /// ****************************************
                /// ---------- Model-Specific Settingsカード ----------
                /// ****************************************
                ///   | ネガティブプロンプトとか
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: double.infinity),
                        Text(
                          "Model-Specific Settings",
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        //-----ネガティブプロンプトテキストフィールド-----
                        TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "ネガティブプロンプト(Undesired Content プロンプト)",
                          ),
                          maxLines: 2,
                          controller: negativePromptTextController,
                          onChanged: (value) {
                            promptData.undesiredPrompt[0] = value;
                            isEditDirty = true;
                          },
                        ),
                        const SizedBox(height: 16),
                        //-----Undesired Contentドロップダウン-----
                        const Text("Undesired Content"),
                        UndesiredContentDropdown(
                          nowValue: promptData.undesiredContent,
                          onChanged: (value) {
                            promptData.undesiredContent = value;
                            isEditDirty = true;
                          },
                        ),
                        //-----クオリティタグを自動的に追加するチェックボックス-----
                        CheckboxListTile(
                          title:
                              const Text("クオリティタグを自動で追加する (Add Quality Tags)"),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: promptData.addQualityTag,
                          onChanged: (value) {
                            setState(() {
                              promptData.addQualityTag = value!;
                            });
                            isEditDirty = true;
                          },
                        ),
                        const SizedBox(height: 8),
                        //-----Steps, Scale, Seed のテキストフィールド
                        buildSpecificSettingsTextField(),
                      ],
                    ),
                  ),
                ),

                /// ****************************************
                /// ---------- 画像設定カード ----------
                /// ****************************************
                ///   | 解像度とか
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: double.infinity),
                        Text(
                          "画像設定",
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        //-----画質設定-----
                        Row(
                          children: [
                            //-----横幅解像度のテキストフィールド-----
                            SizedBox(
                              width: 160,
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "横幅",
                                ),
                                controller: imageWidthTextController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (value) {
                                  final parse = int.tryParse(value);
                                  if (parse != null) {
                                    promptData.width = parse;
                                  }
                                  isEditDirty = true;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text("X"),
                            const SizedBox(width: 8),
                            //-----縦幅解像度のテキストフィールド-----
                            SizedBox(
                              width: 160,
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "縦幅",
                                ),
                                controller: imageHeightTextController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (value) {
                                  final parse = int.tryParse(value);
                                  if (parse != null) {
                                    promptData.height = parse;
                                  }
                                  isEditDirty = true;
                                },
                              ),
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
        ));
  }
}
