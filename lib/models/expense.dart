import 'package:isar/isar.dart';

// Generated isar file
// dart run build_runner build to rebuild
part 'expense.g.dart';

@collection
class Expense {
  Id id = Isar.autoIncrement;
  String detail;
  double value;
  DateTime date;

  Expense({required this.detail, required this.value, required this.date});
}
