import 'dart:convert';
import 'dart:io';

import 'package:novelai_manager/model/json/settings/image_sorter_button_setting.dart';
import 'package:novelai_manager/util/db_util.dart';

import '../model/json/manager_setting.dart';
import '../model/json/settings/image_sorter_setting.dart';

class SettingsRepository {
  static ManagerSetting? _setting;
  static Future<ManagerSetting> getSetting() async {
    if (_setting == null) {
      var dbDir = await DBUtil.getDataBaseFolder();
      var settingsJsonFile = File("${dbDir.path}/settings.json");

      if (await settingsJsonFile.exists()) {
        var jsonText = await settingsJsonFile.readAsString();
        _setting = ManagerSetting.fromJson(_defaultDecode(jsonText));
      } else {
        _setting = ManagerSetting(
            imageSorterSetting: _createDefaultImageSorterSetting());
        await settingsJsonFile.writeAsString(json.encode(_setting!.toJson()));
      }
    }

    return _setting!;
  }

  /// jsonファイルにそのキーの要素が無いときにクラッシュしないように、初期値を入れる
  static _defaultDecode(String jsonText) {
    final jsonObject = json.decode(jsonText);
    // ImageSorterSetting
    if (!jsonObject.containsKey("imageSorterSetting")) {
      jsonObject["imageSorterSetting"] =
          _createDefaultImageSorterSetting().toJson();
    }

    return jsonObject;
  }

  static _createDefaultImageSorterSetting() {
    final imageSorter = ImageSorterSetting();
    imageSorter.buttons = List.empty(growable: true);
    imageSorter.buttons.addAll([
      ImageSorterButtonSetting(
        label: "Good",
        folderName: "Good",
        keys: ["1"],
      ),
      ImageSorterButtonSetting(
        label: "Bad",
        folderName: "Bad",
        keys: ["2"],
      ),
    ]);
    return imageSorter;
  }

  static Future<void> writeSetting(ManagerSetting setting) async {
    _setting = setting;

    var dbDir = await DBUtil.getDataBaseFolder();
    var settingsJsonFile = File("${dbDir.path}/settings.json");

    await settingsJsonFile.writeAsString(json.encode(setting.toJson()));
  }
}
