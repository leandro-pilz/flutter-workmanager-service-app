extension IntExtensions on int {
  DateTime convertIntDateToDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(this);
  }
}

extension DateTimeExtensions on DateTime {
  int convertDateTimeToInt() {
    return millisecondsSinceEpoch;
  }
}
