import 'package:intl/intl.dart';

double stringToDouble(String string) {
  double? value = double.tryParse(string);
  return value ?? 0;
}

String formatValue(double value) {
  final NumberFormat format = NumberFormat.currency(locale: "en_US", symbol: "\$", decimalDigits: 2);
  return format.format(value);
}