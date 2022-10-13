enum UndesiredContent {
  LOWQUALITY_PLUS_BADANATOMY(
      "lowquality_plus_badanatomy", "Low Quality + Bad Anatomy"),
  LOWQUALITY("lowquality", "Low Quality"),
  NONE("none", "None");

  final String value;
  final String name;
  const UndesiredContent(this.value, this.name);

  @override
  String toString() {
    return value;
  }
}
