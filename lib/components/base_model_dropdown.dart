import 'package:flutter/material.dart';

import 'package:novelai_manager/model/nai_base_model.dart';

/// モデルを選択するドロップダウンボタン
/// NAI Diffusion Anime (Full)とかを選択する奴
class BaseModelDropdown extends StatefulWidget {
  //現在選択されてる値を保存する変数
  String? nowValue = NAIBaseModel.NAI_DIFFUSION_ANIME_FULL.value;
  //変更された時に呼ばれるコールバック
  final Function(String) onChanged;

  BaseModelDropdown({
    super.key,
    this.nowValue,
    required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() {
    return _BaseModelDropdown();
  }
}

class _BaseModelDropdown extends State<BaseModelDropdown> {
  //ドロップダウンのリスト
  var baseModelList = [
    NAIBaseModel.NAI_DIFFUSION_ANIME_CURATED,
    NAIBaseModel.NAI_DIFFUSION_ANIME_FULL,
    NAIBaseModel.NAI_DIFFUSION_FURRY,
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: widget.nowValue,
      items: baseModelList.map((value) {
        return DropdownMenuItem(
          value: value.value,
          child: Text(value.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          widget.nowValue = value;
        });

        widget.onChanged(value!);
      },
    );
  }
}
