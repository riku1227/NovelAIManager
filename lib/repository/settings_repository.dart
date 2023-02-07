import 'dart:convert';
import 'dart:io';

import 'package:novelai_manager/util/db_util.dart';

import '../model/json/manager_setting.dart';

class SettingsRepository {
  static ManagerSetting? _setting;
  static Future<ManagerSetting> getSetting() async {
    if (_setting == null) {
      var dbDir = await DBUtil.getDataBaseFolder();
      var settingsJsonFile = File("${dbDir.path}/settings.json");

      if (await settingsJsonFile.exists()) {
        var jsonText = await settingsJsonFile.readAsString();
        _setting = ManagerSetting.fromJson(json.decode(jsonText));
      } else {
        _setting = ManagerSetting();
        await settingsJsonFile.writeAsString(json.encode(_setting!.toJson()));
      }
    }

    return _setting!;
  }

  static Future<void> writeSetting(ManagerSetting setting) async {
    _setting = setting;

    var dbDir = await DBUtil.getDataBaseFolder();
    var settingsJsonFile = File("${dbDir.path}/settings.json");

    await settingsJsonFile.writeAsString(json.encode(setting.toJson()));
  }
}
