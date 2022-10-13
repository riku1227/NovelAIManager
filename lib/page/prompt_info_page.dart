import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novelai_manager/components/dialog/delete_alert_dialog.dart';
import 'package:novelai_manager/components/widget/outline_container.dart';
import 'package:novelai_manager/page/create_gallery_page.dart';
import 'package:novelai_manager/repository/gallery_data_repository.dart';
import 'package:novelai_manager/util/db_util.dart';
import 'package:novelai_manager/util/novel_ai_util.dart';

import '../model/gallery_data.dart';

//プロンプトの情報を表示するページ
class PromptInfoPage extends StatefulWidget {
  GalleryData galleryData;
  PromptInfoPage({super.key, required this.galleryData});

  @override
  State<StatefulWidget> createState() {
    return _PromptInfoPageState();
  }
}

class _PromptInfoPageState extends State<PromptInfoPage> {
  //プロンプト入力欄のテキストコントローラーを収納するリスト
  List<TextEditingController> promptTextControllerList = [];

  var negativePromptTextController = TextEditingController();
  var stepsTextController = TextEditingController();
  var scaleTextController = TextEditingController();
  var seedTextController = TextEditingController();
  var imageWidthTextController = TextEditingController();
  var imageHeightTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  //ギャラリーデータを削除する
  Future<void> deleteGalleryData(BuildContext context) async {
    var navigator = Navigator.of(context);
    var imageList = widget.galleryData.promptData!.generatedImageList;
    if (imageList.isNotEmpty) {
      Directory? deleteDir;
      for (var value in imageList) {
        var file = File(await DBUtil.getImageFullPath(value.imagePath));
        if (await file.exists()) {
          deleteDir ??= file.parent;
          await file.delete();
        }
      }

      if (deleteDir != null) {
        var dirChildList = await deleteDir.list(recursive: true).toList();
        if (dirChildList.isEmpty) {
          await deleteDir.delete();
        }
      }
    }
    var repository = await GalleryDataRepository.getInstance();
    repository.deleteGallery(widget.galleryData);
    navigator.pop();
  }

  Future<void> copyToClipboard(BuildContext context, String copyText) async {
    var messenger = ScaffoldMessenger.of(context);
    var data = ClipboardData(text: copyText);
    await Clipboard.setData(data);
    messenger.showSnackBar(
      const SnackBar(
          duration: Duration(milliseconds: 800),
          content: Text("クリップボードにコピーしました！")),
    );
  }

  @override
  Widget build(BuildContext context) {
    var promptData = widget.galleryData.promptData;
    //何らかの原因でプロンプトデータが存在しないときはエラー画面を出す
    if (promptData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.galleryData.title),
        ),
        body: const Text("プロンプトデータが存在しません"),
      );
    }

    negativePromptTextController.text = promptData.undesiredPrompt[0];
    stepsTextController.text = promptData.steps.toString();
    scaleTextController.text = promptData.scale.toString();
    seedTextController.text =
        promptData.seed.toString().replaceAll(".0", "").replaceAll("null", "");
    imageWidthTextController.text = promptData.width.toString();
    imageHeightTextController.text = promptData.height.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.galleryData.title),
        actions: [
          IconButton(
            onPressed: () async {
              //削除用ダイアログを表示する
              showDialog(
                  context: context,
                  builder: (_) {
                    return const DeleteAlertDialog();
                  }).then((value) {
                if (value == null) {
                  return;
                }
                if (value) {
                  deleteGalleryData(context);
                }
              });
            },
            icon: const Icon(Icons.delete),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return CreateGalleryPage(
                  galleryData: widget.galleryData,
                );
              }))).then((value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  widget.galleryData = value;
                });
              });
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //**************************
          //          左側
          //**************************
          Expanded(
            flex: 4,
            child: ListView.builder(
                itemCount: promptData.generatedImageList.length,
                itemBuilder: (context, pos) {
                  return SizedBox(
                    height: 512,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: OutlineContainer(
                        child: FutureBuilder(
                          future: DBUtil.getImageFullPath(
                              promptData.generatedImageList[pos].imagePath),
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return const Text("読み込み中");
                            } else {
                              if (snapshot.data == "") {
                                return const Text("画像が存在しません");
                              } else {
                                return Image.file(File(snapshot.data!));
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  );
                }),
          ),
          const SizedBox(
            width: 8,
          ),
          //**************************
          //          右側
          //**************************
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: double.infinity,
                            ),
                            Text(
                              widget.galleryData.title,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            Text(promptData.description),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: double.infinity,
                            ),
                            Text(
                              "基本設定",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "モデル: ${NovelAIUtil.getBaseModelNamebyValue(promptData.baseModel)}",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            //プロンプト入力欄
                            Text(
                              "プロンプト",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: promptData.prompt.length,
                              itemBuilder: ((context, index) {
                                if (promptTextControllerList.length - 1 <
                                    index) {
                                  promptTextControllerList
                                      .add(TextEditingController());
                                  promptTextControllerList[index].text =
                                      promptData.prompt[index];
                                }
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                          maxLines: 2,
                                          controller:
                                              promptTextControllerList[index],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          copyToClipboard(
                                              context,
                                              promptTextControllerList[index]
                                                  .text);
                                        },
                                        icon: const Icon(Icons.copy),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: double.infinity,
                            ),
                            Text(
                              "Model-Specific Settings",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Undesired Content:",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  "[ ${NovelAIUtil.getUndesiredContentNamebyValue(promptData.undesiredContent)} ]",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "ネガティブ(Undesired Content)プロンプト",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Row(
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
                                IconButton(
                                  onPressed: () {
                                    copyToClipboard(context,
                                        negativePromptTextController.text);
                                  },
                                  icon: const Icon(Icons.copy),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            CheckboxListTile(
                              title: const Text("クオリティタグを自動的に追加する"),
                              value: promptData.addQualityTag,
                              onChanged: (e) {},
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Row(
                                    children: [
                                      const Text("Steps"),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                          child: TextField(
                                        controller: stepsTextController,
                                      )),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      const Text("Scale"),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                          child: TextField(
                                        controller: scaleTextController,
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Seed",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    controller: seedTextController,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    copyToClipboard(
                                        context, seedTextController.text);
                                  },
                                  icon: const Icon(Icons.copy),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: double.infinity,
                            ),
                            Text(
                              "画像設定",
                              style: Theme.of(context).textTheme.headline5,
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
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () {
                                    copyToClipboard(
                                        context, imageWidthTextController.text);
                                  },
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
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () {
                                    copyToClipboard(context,
                                        imageHeightTextController.text);
                                  },
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
            ),
          ),
        ],
      ),
    );
  }
}
