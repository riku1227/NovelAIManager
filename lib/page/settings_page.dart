import 'package:flutter/material.dart';

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
  bool _isAutoCheckForUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: MyScrollView(
        child: Column(
          children: <Widget>[
            SwitchListTile(
              title: const Text('テスト設定'),
              value: _isAutoCheckForUpdates,
              onChanged: (bool value) {
                setState(() {
                  _isAutoCheckForUpdates = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
