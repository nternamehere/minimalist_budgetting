import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:minimalist_budgetting/models/expense.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseController extends ChangeNotifier {
  static late Isar isar;
  final List<Expense> _expenses = [];

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  List<Expense> get expenses => _expenses;

  Future<void> create(Expense expense) async {
    await isar.writeTxn(() => isar.expenses.put(expense));

    _expenses.add(expense);
    notifyListeners();
  }

  Future<Expense?> read(int id) async {
    final Expense? expense = await isar.expenses.get(id);
    return expense;
  }

  Future<void> update(int id, Expense expense) async {
    expense.id = id;

    await isar.writeTxn(() => isar.expenses.put(expense));

    int index = _expenses.indexWhere((c) => c.id == id);
    _expenses.replaceRange(index, index + 1, [expense]);
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() => isar.expenses.delete(id));

    int index = _expenses.indexWhere((c) => c.id == id);
    _expenses.removeAt(index);
    notifyListeners();
  }

  Future<void> list() async {
    List<Expense> expenses = await isar.expenses.where().findAll();
    _expenses.clear();
    _expenses.addAll(expenses);

    notifyListeners();
  }

  Future<Map<String, double>> calculateMonthlyTotals() async {
    await list();

    Map<String, double> monthlyTotals = {};

    for (var expense in _expenses) {
      String yearMonth = '${expense.date.year}-${expense.date.month}';

      if (!monthlyTotals.containsKey(yearMonth)) {
        monthlyTotals[yearMonth] = 0;
      }

      monthlyTotals[yearMonth] = monthlyTotals[yearMonth]! + expense.value;
    }

    return monthlyTotals;
  }

  DateTime startDateTime() {
    if (_expenses.isEmpty) {
      DateTime now = DateTime.now();
      return DateTime(now.year - 1, now.month, now.day);
    }

    _expenses.sort((a, b) => a.date.compareTo(b.date));

    return _expenses.first.date;
  }

  Future<double> calculateCurrentMonthTotal() async {
    await list();

    DateTime now = DateTime.now();

    List<Expense> currentMonthExpenses = _expenses.where((expense) {
      return expense.date.year == now.year && expense.date.month == now.month;
    }).toList();

    double total =
        currentMonthExpenses.fold(0, (sum, expense) => sum + expense.value);

    return total;
  }
}
