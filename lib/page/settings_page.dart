import 'package:flutter/material.dart';
import 'package:novelai_manager/repository/settings_repository.dart';

import '../components/widget/my_scroll_view.dart';

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
      body: MyScrollView(
        child: FutureBuilder(
          future: SettingsRepository.getSetting(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
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
