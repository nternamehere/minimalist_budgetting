import 'package:isar/isar.dart';
import 'package:minimalist_budgetting/models/budget.dart';
import 'package:minimalist_budgetting/models/expense.dart';

// Generated isar file
// dart run build_runner build to rebuild
part 'category.g.dart';

@Collection(accessor: 'categories')
class Category {
  Id id = Isar.autoIncrement;
  String name;
  bool archived = false;

  // @Backlink(to: 'category')
  // final expenses = IsarLinks<Expense>();

  @Backlink(to: 'category')
  final budgets = IsarLinks<Budget>();

  Category({required this.name});
}
