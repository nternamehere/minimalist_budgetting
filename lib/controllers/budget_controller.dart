import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:minimalist_budgetting/models/budget.dart';
import 'package:minimalist_budgetting/models/category.dart';
import 'package:path_provider/path_provider.dart';

class BudgetController extends ChangeNotifier {
  static late Isar isar;
  final List<Budget> _budgets = [];

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([BudgetSchema, CategorySchema], directory: dir.path);
  }

  List<Budget> get budgets => _budgets;

  Future<void> create(Budget budget) async {
    await isar.writeTxn(() => isar.budgets.put(budget));

    _budgets.add(budget);
    notifyListeners();
  }

  Future<Budget?> read(int id) async {
    final Budget? budget = await isar.budgets.get(id);
    return budget;
  }

  Future<void> update(int id, Budget budget) async {
    budget.id = id;

    await isar.writeTxn(() => isar.budgets.put(budget));

    int index = _budgets.indexWhere((c) => c.id == id);
    _budgets.replaceRange(index, index + 1, [budget]);
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() => isar.budgets.delete(id));

    int index = _budgets.indexWhere((c) => c.id == id);
    _budgets.removeAt(index);
    notifyListeners();
  }

  Future<void> list() async {
    List<Budget> budgets = await isar.budgets.where().findAll();
    _budgets.clear();
    _budgets.addAll(budgets);

    notifyListeners();
  }
}
