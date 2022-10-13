enum SamplingModel {
  k_euler_ancestral("k_euler_ancestral"),
  k_euler("k_euler"),
  k_lms("k_lms"),
  plms("plms"),
  ddim("ddim");

  final value;

  const SamplingModel(this.value);

  @override
  String toString() {
    return value;
  }
}
