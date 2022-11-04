import 'dart:math';
import 'dart:typed_data';

class HexUtil {
  /// Uint8Listから10進数の数字に変換する
  static int convertToDecimalNumber(Uint8List data) {
    var result = 0;
    for (var i = 0; i < data.length; i++) {
      result += data[data.length - i - 1] * max(1, pow(16, i * 2).toInt());
    }

    return result;
  }
}
