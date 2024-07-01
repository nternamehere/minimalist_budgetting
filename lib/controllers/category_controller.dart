import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:minimalist_budgetting/models/budget.dart';
import 'package:minimalist_budgetting/models/category.dart';
import 'package:path_provider/path_provider.dart';

class CategoryController extends ChangeNotifier {
  static late Isar isar;
  final List<Category> _categories = [];

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([CategorySchema, BudgetSchema], directory: dir.path);
  }

  List<Category> get categories => _categories;

  Future<void> create(Category category) async {
    await isar.writeTxn(() => isar.categories.put(category));

    _categories.add(category);
    notifyListeners();
  }

  Future<Category?> read(int id) async {
    final Category? category = await isar.categories.get(id);
    return category;
  }

  Future<void> update(int id, Category category) async {
    category.id = id;

    await isar.writeTxn(() => isar.categories.put(category));

    int index = _categories.indexWhere((c) => c.id == id);
    _categories.replaceRange(index, index + 1, [category]);
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() => isar.categories.delete(id));

    int index = _categories.indexWhere((c) => c.id == id);
    _categories.removeAt(index);
    notifyListeners();
  }

  Future<void> list() async {
    List<Category> categories = await isar.categories.where().findAll();
    _categories.clear();
    _categories.addAll(categories);

    notifyListeners();
  }
}
