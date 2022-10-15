import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novelai_manager/components/base_model_dropdown.dart';
import 'package:novelai_manager/components/undesired_content_dropdown.dart';
import 'package:novelai_manager/components/widget/outline_container.dart';
import 'package:novelai_manager/model/gallery_data.dart';
import 'package:novelai_manager/repository/gallery_data_repository.dart';
import 'package:novelai_manager/util/db_util.dart';
import 'package:realm/realm.dart';
import 'package:path/path.dart';

//ギャラリーを新しく作成するページ
class CreateGalleryPage extends StatefulWidget {
  GalleryData? galleryData;
  CreateGalleryPage({super.key, this.galleryData});

  @override
  State<StatefulWidget> createState() {
    return _CreateGalleryPageState();
  }
}

class _CreateGalleryPageState extends State<CreateGalleryPage> {
  late GalleryData galleryData;

  /// 登録する画像のファイルパスが入るリスト
  /// 保存するときにそこからデータベースフォルダにコピーして、ギャラリーデータにはそこのパスを入れる
  List<String> imageFilePathList = [];

  var galleryTitleTextController = TextEditingController();
  var galleryDescriptionTextController = TextEditingController();

  List<TextEditingController> promptTextControllerList = [];
  var negativePromptTextController = TextEditingController();

  var stepsTextController = TextEditingController();
  var scaleTextController = TextEditingController();
  var seedTextController = TextEditingController();

  var imageWidthTextController = TextEditingController();
  var imageHeightTextController = TextEditingController();

  @override
  void initState() {
    var promptData = PromptData(Uuid.v4());
    galleryData = GalleryData(Uuid.v4(), "", DateTime.now(), DateTime.now())
      ..promptData = promptData;

    if (widget.galleryData != null) {
      ///TODO 世界一のクソコードをなんとかする
      var baseGalleryData = widget.galleryData!;
      galleryData.id = baseGalleryData.id;
      galleryData.title = baseGalleryData.title;
      galleryData.createdAt = baseGalleryData.createdAt;
      galleryData.isFolder = baseGalleryData.isFolder;
      galleryData.promptData!.id = baseGalleryData.promptData!.id;
      galleryData.promptData!.description =
          baseGalleryData.promptData!.description;
      galleryData.promptData!.generatedImageList
          .addAll(baseGalleryData.promptData!.generatedImageList);
      galleryData.promptData!.prompt.addAll(baseGalleryData.promptData!.prompt);
      galleryData.promptData!.baseModel = baseGalleryData.promptData!.baseModel;
      galleryData.promptData!.width = baseGalleryData.promptData!.width;
      galleryData.promptData!.height = baseGalleryData.promptData!.height;
      galleryData.promptData!.strength = baseGalleryData.promptData!.strength;
      galleryData.promptData!.noise = baseGalleryData.promptData!.noise;
      galleryData.promptData!.undesiredPrompt
          .addAll(baseGalleryData.promptData!.undesiredPrompt);
      galleryData.promptData!.undesiredContent =
          baseGalleryData.promptData!.undesiredContent;
      galleryData.promptData!.addQualityTag =
          baseGalleryData.promptData!.addQualityTag;
      galleryData.promptData!.steps = baseGalleryData.promptData!.steps;
      galleryData.promptData!.scale = baseGalleryData.promptData!.scale;
      galleryData.promptData!.seed = baseGalleryData.promptData!.seed;
      galleryData.promptData!.sampling = baseGalleryData.promptData!.sampling;
    } else {
      galleryData.promptData!.prompt.add("");
      galleryData.promptData!.undesiredPrompt.add("");
    }

    for (var item in galleryData.promptData!.generatedImageList) {
      imageFilePathList.add(item.imagePath);
    }

    galleryTitleTextController.text = galleryData.title;
    galleryDescriptionTextController.text = galleryData.promptData!.description;

    negativePromptTextController.text =
        galleryData.promptData!.undesiredPrompt[0];

    stepsTextController.text = galleryData.promptData!.steps.toString();
    scaleTextController.text = galleryData.promptData!.scale.toString();
    seedTextController.text = galleryData.promptData!.seed
        .toString()
        .replaceAll(".0", "")
        .replaceAll("null", "");

    imageWidthTextController.text = galleryData.promptData!.width.toString();
    imageHeightTextController.text = galleryData.promptData!.height.toString();
    super.initState();
  }

  void pickGeneratedImage() async {
    var filePaths = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (filePaths == null) {
      return;
    }

    for (var value in filePaths.paths) {
      if (value != null) {
        setState(() {
          imageFilePathList.add(value);
        });
      }
    }
  }

  ///登録された画像をデータベースに登録する
  Future<void> copyImageFileToDB() async {
    if (galleryData.promptData!.generatedImageList.isNotEmpty) {
      galleryData.promptData!.generatedImageList
          .removeRange(0, galleryData.promptData!.generatedImageList.length);
    }
    // ファイル名に使えない文字をアンダーバーに置き換えた後の文字列
    var escapeTitle =
        galleryData.title.replaceAll(RegExp(r'"|<|>|\||:|\*|\?|\\|\/'), '_');
    //データーベースの画像を保存するフォルダ
    var imgDir = await GalleryDataRepository.getDataBaseImgFolder();
    //コピー先のフォルダ
    var copyFolder = Directory("${imgDir.path}/$escapeTitle");
    if (!await copyFolder.exists()) {
      await copyFolder.create();
    }
    for (var value in imageFilePathList) {
      //コピー元のファイル
      var originalFile = File(await DBUtil.getImageFullPath(value));
      //コピー先のファイルパス
      var copyPath = "${copyFolder.path}/${basename(originalFile.path)}";

      /// コピー先のファイルパスをDBに登録
      /// 実行ファイルがあるフォルダからの相対パスを登録する
      galleryData.promptData!.generatedImageList.add(
          ImageData(Uuid.v4(), "$escapeTitle/${basename(originalFile.path)}"));

      /// コピー元とコピー先が同じだと何もしない
      var copyFile = File(copyPath);
      if (copyFile.path == originalFile.path) {
        continue;
      }
      //コピー
      await originalFile.copy(copyPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("ギャラリーを新規作成"),
        actions: [
          IconButton(
            onPressed: () async {
              var promptData = galleryData.promptData!;
              if (galleryData.title.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("タイトルが入力されていません"),
                  duration: Duration(milliseconds: 850),
                ));
                return;
              }

              if (promptData.prompt.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("プロンプトが入力されていません"),
                  duration: Duration(milliseconds: 850),
                ));
                return;
              }

              /// 非同期処理した後のコンテキストだとエラー出すので
              /// 処理前に先に作っておく
              var navigator = Navigator.of(context);

              //画像をDBにコピー
              await copyImageFileToDB();

              //作成日 / 更新日 を更新
              if (widget.galleryData == null) {
                galleryData.createdAt = DateTime.now();
              }
              galleryData.updatedAt = DateTime.now();

              var repo = await GalleryDataRepository.getInstance();
              await repo.addGallery(galleryData);
              navigator.pop(galleryData);
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //画像一覧
            Padding(
              padding: const EdgeInsets.all(8),
              child: DropTarget(
                onDragDone: ((details) {
                  for (var item in details.files) {
                    imageFilePathList.add(item.path);
                  }
                  setState(() {});
                }),
                child: OutlineContainer(
                  child: SizedBox(
                    height: 320,
                    child: ListView.builder(
                      itemCount: imageFilePathList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              FutureBuilder(
                                  future: DBUtil.getImageFullPath(
                                      imageFilePathList[index]),
                                  builder: ((context, snapshot) {
                                    if (snapshot.data == null) {
                                      return const Text("読み込み中");
                                    } else {
                                      if (snapshot.data == "") {
                                        return const Text("画像が存在しません");
                                      } else {
                                        return Image.file(File(snapshot.data!));
                                      }
                                    }
                                  })),
                              //削除ボタン
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: ElevatedButton(
                                  child: const Icon(Icons.remove_circle),
                                  onPressed: () {
                                    setState(() {
                                      imageFilePathList.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
            //画像を追加するボタン
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: OutlinedButton.icon(
                    onPressed: pickGeneratedImage,
                    icon: const Icon(Icons.photo),
                    label: const Text("画像を追加する"),
                  ),
                ),
              ],
            ),

            //画像一覧と基本設定の仕切り
            const Padding(
              padding: EdgeInsets.only(
                left: 8,
                right: 8,
              ),
              child: Divider(
                height: 32,
              ),
            ),

            //プロンプトカード
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// カードを横幅いっぱいにするためのSizedBox
                    /// CrossAxisAlignment.stretch だと中の要素全てが横幅いっぱいになる
                    /// TODO なんか気持ち悪くはあるからもっと良い感じの解決策は欲しい
                    const SizedBox(
                      width: double.infinity,
                    ),
                    Text(
                      "基本設定",
                      style: theme.textTheme.titleLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "ギャラリーのタイトル",
                        ),
                        maxLines: 1,
                        controller: galleryTitleTextController,
                        onChanged: (value) {
                          galleryData.title = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "ギャラリーの説明",
                        ),
                        minLines: 2,
                        maxLines: 3,
                        controller: galleryDescriptionTextController,
                        onChanged: (value) {
                          galleryData.promptData!.description = value;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text("モデル"),
                    BaseModelDropdown(
                      nowValue: galleryData.promptData!.baseModel,
                      onChanged: (value) {
                        setState(() {
                          galleryData.promptData!.baseModel = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text("プロンプト"),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: galleryData.promptData!.prompt.length,
                      itemBuilder: ((context, index) {
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
                                    galleryData.promptData!.prompt[index] =
                                        value;
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    galleryData.promptData!.prompt
                                        .removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          galleryData.promptData!.prompt.add("");
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("プロンプトを追加する"),
                    )
                  ],
                ),
              ),
            ),

            //ネガティブプロンプトカード
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// カードを横幅いっぱいにするためのSizedBox
                    /// CrossAxisAlignment.stretch だと中の要素全てが横幅いっぱいになる
                    /// TODO なんか気持ち悪くはあるからもっと良い感じの解決策は欲しい
                    const SizedBox(
                      width: double.infinity,
                    ),
                    Text(
                      "Model-Specific Settings",
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "ネガティブプロンプト(Undesired Content プロンプト)",
                      ),
                      maxLines: 2,
                      controller: negativePromptTextController,
                      onChanged: (value) {
                        galleryData.promptData!.undesiredPrompt[0] = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text("Undesired Content"),
                    UndesiredContentDropdown(
                        nowValue: galleryData.promptData!.undesiredContent,
                        onChanged: (value) {
                          galleryData.promptData!.undesiredContent = value;
                        }),
                    CheckboxListTile(
                      title: const Text("クオリティタグを自動で追加する (Add Quality Tags)"),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: galleryData.promptData!.addQualityTag,
                      onChanged: (value) {
                        setState(() {
                          galleryData.promptData!.addQualityTag = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            maxLength: 3,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Steps",
                              counterText: "",
                            ),
                            controller: stepsTextController,
                            onChanged: (value) {
                              var parse = int.tryParse(value);
                              if (parse != null) {
                                galleryData.promptData!.steps = parse;
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            maxLength: 3,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Scale",
                              counterText: "",
                            ),
                            controller: scaleTextController,
                            onChanged: (value) {
                              var parse = int.tryParse(value);
                              if (parse != null) {
                                galleryData.promptData!.scale = parse;
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 7,
                          child: TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Seed",
                            ),
                            controller: seedTextController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              var parse = double.tryParse(value);
                              if (parse != null) {
                                galleryData.promptData!.seed = parse;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //画像設定
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// カードを横幅いっぱいにするためのSizedBox
                    /// CrossAxisAlignment.stretch だと中の要素全てが横幅いっぱいになる
                    /// TODO なんか気持ち悪くはあるからもっと良い感じの解決策は欲しい
                    const SizedBox(
                      width: double.infinity,
                    ),

                    Text(
                      "画像設定",
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
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
                              var parse = int.tryParse(value);
                              if (parse != null) {
                                galleryData.promptData!.width = parse;
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text("X"),
                        const SizedBox(width: 8),
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
                              var parse = int.tryParse(value);
                              if (parse != null) {
                                galleryData.promptData!.height = parse;
                              }
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
    );
  }
}
