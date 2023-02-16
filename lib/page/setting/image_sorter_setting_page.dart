import 'package:flutter/material.dart';
import 'package:novelai_manager/components/widget/outline_container.dart';
import 'package:novelai_manager/model/json/settings/image_sorter_button_setting.dart';
import 'package:novelai_manager/repository/settings_repository.dart';

class ImageSorterSettingPage extends StatefulWidget {
  const ImageSorterSettingPage({Key? key}) : super(key: key);

  /// Navigator用のRouteを取得する
  static MaterialPageRoute getRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return const ImageSorterSettingPage();
      },
    );
  }

  @override
  State<StatefulWidget> createState() => _ImageSorterSettingPageState();
}

class _ImageSorterSettingPageState extends State<ImageSorterSettingPage> {
  // 「ボタンのラベル」テキストフィールド用のコントローラーリスト
  List<TextEditingController> buttonLabelTextControllerList =
      List.empty(growable: true);

  // 「フォルダー名」テキストフィールド用のコントローラーリスト
  List<TextEditingController> buttonFolderNameTextControllerList =
      List.empty(growable: true);

  // 「キー」テキストフィールド用のコントローラーリスト
  List<TextEditingController> buttonKeyTextControllerList =
      List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定 - Image Sorter"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: SettingsRepository.getSetting(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final settings = snapshot.data!;
              final imageSorterSettings = settings.imageSorterSetting;
              return Column(
                children: [
                  const ListTile(
                    title: Text("基本設定"),
                  ),
                  SwitchListTile(
                    title: const Text('読み込んだ画像をランダムで表示する'),
                    value: imageSorterSettings.isRandomDisplay,
                    onChanged: (bool? newValue) async {
                      setState(() {
                        imageSorterSettings.isRandomDisplay = newValue ?? false;
                      });
                      await SettingsRepository.writeSetting(settings);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('画像を移動では無くコピーさせる'),
                    value: imageSorterSettings.isCopyFile,
                    onChanged: (bool? newValue) async {
                      setState(() {
                        imageSorterSettings.isCopyFile = newValue ?? false;
                      });
                      await SettingsRepository.writeSetting(settings);
                    },
                  ),
                  const Divider(),
                  const ListTile(
                    title: Text("ボタン/キーバインド 設定"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 180,
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                imageSorterSettings.buttons
                                    .add(ImageSorterButtonSetting(
                                  label: "ラベル",
                                  folderName: "folder",
                                  keys: [""],
                                ));
                              });
                            },
                            child: const Text("追加する"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OutlineContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: imageSorterSettings.buttons.length,
                          separatorBuilder: (context, index) {
                            return const Divider(height: 24);
                          },
                          itemBuilder: (context, index) {
                            final button = imageSorterSettings.buttons[index];

                            if (buttonLabelTextControllerList.length - 1 <
                                index) {
                              buttonLabelTextControllerList
                                  .add(TextEditingController());
                              buttonLabelTextControllerList[index].text =
                                  button.label;
                            }

                            if (buttonFolderNameTextControllerList.length - 1 <
                                index) {
                              buttonFolderNameTextControllerList
                                  .add(TextEditingController());
                              buttonFolderNameTextControllerList[index].text =
                                  button.folderName;
                            }

                            if (buttonKeyTextControllerList.length - 1 <
                                index) {
                              buttonKeyTextControllerList
                                  .add(TextEditingController());
                              buttonKeyTextControllerList[index].text =
                                  button.keys[0];
                            }

                            return Row(
                              children: [
                                SizedBox(
                                  width: 160,
                                  height: 64,
                                  child: Card(
                                    child: FilledButton(
                                      onPressed: () {},
                                      child: Text(
                                          "${button.label} ${button.keys.toString()}"),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: TextField(
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "ボタンのラベル",
                                              ),
                                              controller:
                                                  buttonLabelTextControllerList[
                                                      index],
                                              onChanged: (value) {
                                                setState(() {
                                                  button.label = value;
                                                });
                                                SettingsRepository.writeSetting(
                                                    settings);
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            flex: 5,
                                            child: TextField(
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "フォルダ名",
                                              ),
                                              controller:
                                                  buttonFolderNameTextControllerList[
                                                      index],
                                              onChanged: (value) {
                                                setState(() {
                                                  button.folderName = value;
                                                });
                                                SettingsRepository.writeSetting(
                                                    settings);
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          SizedBox(
                                            width: 48,
                                            child: TextField(
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                counterText: "",
                                                labelText: "キー",
                                              ),
                                              maxLength: 1,
                                              controller:
                                                  buttonKeyTextControllerList[
                                                      index],
                                              onChanged: (value) {
                                                setState(() {
                                                  button.keys[0] = value;
                                                });
                                                SettingsRepository.writeSetting(
                                                    settings);
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          IconButton(
                                            onPressed: () {
                                              if (imageSorterSettings
                                                      .buttons.length ==
                                                  1) {
                                                return;
                                              }
                                              setState(() {
                                                imageSorterSettings.buttons
                                                    .removeAt(index);
                                                buttonLabelTextControllerList
                                                    .clear();
                                                buttonFolderNameTextControllerList
                                                    .clear();
                                                buttonKeyTextControllerList
                                                    .clear();
                                              });
                                            },
                                            icon: const Icon(Icons.delete),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Text("読み込み中");
            }
          },
        ),
      ),
    );
  }
}
