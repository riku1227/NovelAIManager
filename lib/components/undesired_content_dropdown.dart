import 'package:flutter/material.dart';
import 'package:novelai_manager/model/undesired_content.dart';

/// UndesiredContentを選択するドロップダウンボタン
/// Low Quality + Bad Anatomy とか
class UndesiredContentDropdown extends StatefulWidget {
  //現在選択されてる値を保存する変数
  String? nowValue = "";
  //原稿された時に呼ばれるコールバック
  final Function(String) onChanged;

  UndesiredContentDropdown({super.key, this.nowValue, required this.onChanged});

  @override
  State<StatefulWidget> createState() {
    return _UndesiredContentDropdownState();
  }
}

class _UndesiredContentDropdownState extends State<UndesiredContentDropdown> {
  final undesiredContentList = [
    UndesiredContent.LOWQUALITY_PLUS_BADANATOMY,
    UndesiredContent.LOWQUALITY,
    UndesiredContent.NONE,
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: widget.nowValue,
      items: undesiredContentList.map((value) {
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
