// extension on String

extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
     // return EMPTY;
      return "";
    } else {
      return this!;
    }
  }
}
// extension on Integer
extension NonNullInteger on int? {
  int orZero() {
    if (this == null) {
      //return ZERO;
      return 0;
    } else {
      return this!;
    }
  }
}