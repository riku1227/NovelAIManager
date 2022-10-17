/// Enumは大文字で書きたい...
// ignore_for_file: constant_identifier_names

enum NAIUndesiredContent {
  LOWQUALITY_PLUS_BADANATOMY(
      "lowquality_plus_badanatomy", "Low Quality + Bad Anatomy"),
  LOWQUALITY("lowquality", "Low Quality"),
  NONE("none", "None");

  final String value;
  final String name;
  const NAIUndesiredContent(this.value, this.name);

  @override
  String toString() {
    return value;
  }

  /// Enumの名前をvalueから取得する
  static String getNameByValue(String value) {
    var result = "";
    if (NAIUndesiredContent.LOWQUALITY_PLUS_BADANATOMY.value == value) {
      result = NAIUndesiredContent.LOWQUALITY_PLUS_BADANATOMY.name;
    } else if (NAIUndesiredContent.LOWQUALITY.value == value) {
      result = NAIUndesiredContent.LOWQUALITY.name;
    } else if (NAIUndesiredContent.NONE.value == value) {
      result = NAIUndesiredContent.NONE.value;
    }

    return result;
  }
}
