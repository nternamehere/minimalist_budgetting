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
    return date;
  } on FormatException {
    return DateTime.now();
  }
}
