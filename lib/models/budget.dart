import 'package:isar/isar.dart';
import 'package:minimalist_budgetting/models/category.dart';

// Generated isar file
// dart run build_runner build to rebuild
part 'budget.g.dart';

@collection
class Budget {
  Id id = Isar.autoIncrement;
  int value;
  final category = IsarLink<Category>();

  Budget({required this.value});
}
