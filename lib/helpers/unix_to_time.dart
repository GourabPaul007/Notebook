String unixToTime(int unixTimestamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTimestamp);
  // DateFormat()
  String time = "${dateTime.hour.toString()}:${dateTime.minute.toString()}";

  return time;
}
