String unixToTime(int unixTimestamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTimestamp);
  // DateFormat()
  String hour = dateTime.hour < 10 ? "0${dateTime.hour.toString()}" : dateTime.hour.toString();
  String minute = dateTime.minute < 10 ? "0${dateTime.minute.toString()}" : dateTime.minute.toString();
  String time = "$hour:$minute";

  return time;
}

String unixToDate(int unixTimestamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTimestamp);
  String day = dateTime.day < 10 ? "0${dateTime.day.toString()}" : dateTime.day.toString();
  String month = dateTime.month < 10 ? "0${dateTime.month.toString()}" : dateTime.month.toString();
  String time = "$day:$month:${dateTime.year.toString()}";

  return time;
}
