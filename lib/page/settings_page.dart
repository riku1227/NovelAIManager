import 'package:flutter/material.dart';
import 'package:novelai_manager/repository/settings_repository.dart';

import '../novelai_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  /// Navigator用のRouteを取得する
  static MaterialPageRoute getRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return const SettingsPage();
      },
    );
  }

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: SettingsRepository.getSetting(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  const ListTile(
                    title: Text("基本設定"),
                  ),
                  SwitchListTile(
                    title: const Text('自動的にソフトの更新を確認する'),
                    secondary: const Icon(Icons.update),
                    value: snapshot.data!.isAutoCheckForUpdates,
                    onChanged: (bool value) async {
                      setState(() {
                        snapshot.data!.isAutoCheckForUpdates = value;
                      });
                      await SettingsRepository.writeSetting(snapshot.data!);
                    },
                  ),
                  const ListTile(
                    title: Text("その他"),
                  ),
                  ListTile(
                    title: const Text("ソフトウェアの情報"),
                    leading: const Icon(Icons.info),
                    onTap: () {
                      showAboutDialog(
                          context: context,
                          applicationVersion: NovelAIManager.version,
                          applicationIcon: SizedBox(
                            width: 64,
                            height: 64,
                            child: Image.asset("assets/images/icon.png"),
                          ),
                          applicationLegalese:
                              "プロンプト変換機能(アルゴリズム)\nhttps://github.com/naisd5ch/novel-ai-5ch-wiki-js\n\nこのソフトのソースコード\nhttps://github.com/riku1227/NovelAIManager");
                    },
                  ),
                ],
              );
            } else {
              return const Text("読み込み中...");
            }
          },
        ),
      ),
    );
  }
}
