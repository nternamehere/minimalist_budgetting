import 'package:intl/intl.dart';

String currentDate() {
  var now = DateTime.now();
  var formatter = DateFormat('MM-dd');
  String formattedDate = formatter.format(now);
  return formattedDate;
}

DateTime dateFromString(String string) {
  try {
    DateTime date = DateFormat('MM-dd').parse(string);
    return DateTime(DateTime.now().year, date.month, date.day);
  } on FormatException {
    return DateTime.now();
  }
}

int calculateMonthCount(DateTime current, DateTime start) {
  int monthCount =
      (current.year - start.year) * 12 + current.month - start.month + 1;
  return monthCount;
}

String get currentMonthName {
  return monthNames[DateTime.now().month - 1];
}

List<String> get monthNames {
  return [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC"
  ];
}