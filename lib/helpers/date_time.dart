String unixToTime(int unixTimestamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTimestamp);
  String hour = dateTime.hour < 10 ? "0${dateTime.hour.toString()}" : dateTime.hour.toString();
  String minute = dateTime.minute < 10 ? "0${dateTime.minute.toString()}" : dateTime.minute.toString();
  String time = "$hour:$minute";
  return time;
}

String unixToDate(int unixTimestamp) {
  final now = DateTime.now();
  final then = DateTime.fromMillisecondsSinceEpoch(unixTimestamp);
  if (now.day - then.day == 0) {
    return "Today";
  }
  if (now.day - then.day == 1) {
    return "Yesterday";
  }

  final timeDelay = now.millisecondsSinceEpoch - unixTimestamp;
  // Return weekday of timeStamp
  if (timeDelay > 172800000 && timeDelay <= 604800000) {
    switch (then.weekday) {
      case 1:
        return "mon";
      case 2:
        return "tue";
      case 3:
        return "wed";
      case 4:
        return "thu";
      case 5:
        return "fri";
      case 6:
        return "sat";
      case 7:
        return "sun";
      default:
        return "";
    }
  }
  // If older than a week
  if (timeDelay > 604800000) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTimestamp);
    String day = dateTime.day < 10 ? "0${dateTime.day.toString()}" : dateTime.day.toString();
    String month = dateTime.month < 10 ? "0${dateTime.month.toString()}" : dateTime.month.toString();
    String time = "$day/$month/${dateTime.year.toString().substring(2)}";
    return time;
  }
  // If all else fails...
  return "";
}
