import 'package:flutter/material.dart';
import 'package:minimalist_budgetting/widgets/expense_tile.dart';
import 'package:provider/provider.dart';
import 'package:minimalist_budgetting/controllers/expenses_controller.dart';
import 'package:minimalist_budgetting/helpers/date_helpers.dart';
import 'package:minimalist_budgetting/helpers/value_helpers.dart';
import 'package:minimalist_budgetting/models/expense.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController detailController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController dateController =
      TextEditingController(text: currentDate());

  @override
  void initState() {
    Provider.of<ExpenseController>(context, listen: false).list();

    super.initState();
  }

  void openNewExpenseBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: detailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Expense Detail',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Expense Value',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Date of Expense',
              ),
              keyboardType: TextInputType.datetime,
            )
          ],
        ),
        actions: [
          _createButton(),
          _cancelButton(),
        ],
      ),
    );
  }

  void openDeleteBox(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete expense"),
        actions: [
          _deleteButton(expense),
          _cancelButton(),
        ],
      ),
    );
  }

  void openEditBox(Expense expense) {
    String detail = expense.detail;
    String value = expense.value.toString();

    detailController.text = detail;
    valueController.text = value;
    

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: detailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Expense Detail',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Expense Value',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Date of Expense',
              ),
              keyboardType: TextInputType.datetime,
            )
          ],
        ),
        actions: [
          _editButton(expense),
          _cancelButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseController>(
      builder: (context, value, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: openNewExpenseBox,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.expenses.length,
          itemBuilder: (context, index) {
            Expense expense = value.expenses[index];
            return ExpenseTile(
              title: expense.detail,
              value: formatValue(expense.value),
              onDeletePressed: (context) => openDeleteBox(expense),
              onEditPressed: (context) => openEditBox(expense),
            );
          },
          )
      )
    );
  }

  Widget _createButton() {
    return MaterialButton(
      onPressed: () async {
        String detail = detailController.text;
        String value = valueController.text;
        String date = dateController.text;

        if (detail.isNotEmpty && value.isNotEmpty && date.isNotEmpty) {
          Navigator.pop(context);

          Expense expense = Expense(date: dateFromString(date), detail: detail, value: stringToDouble(value));
          await context.read<ExpenseController>().create(expense);

          _resetTextControllers();
        }
      },
      child: const Text('Create'),
    );
  }

  Widget _editButton(Expense expense) {
    return MaterialButton(
      onPressed: () async {
        String detail = detailController.text;
        String value = valueController.text;
        String date = dateController.text;

        if (detail.isNotEmpty || value.isNotEmpty || date.isNotEmpty) {
          Navigator.pop(context);

          Expense updatedExpense = Expense(date: dateFromString(date), detail: detail, value: stringToDouble(value));
          await context.read<ExpenseController>().update(expense.id, updatedExpense);

          _resetTextControllers();
        }
      },
      child: const Text('Edit'),
    );
  }

  Widget _cancelButton() {
    return MaterialButton(
      onPressed: () {
        Navigator.pop(context);
        _resetTextControllers();
      },
      child: const Text('Cancel'),
    );
  }

  Widget _deleteButton(Expense expense) {
    return MaterialButton(
      onPressed: () async {
        Navigator.pop(context);
        await context.read<ExpenseController>().delete(expense.id);
      },
      child: const Text('Delete'),
    );
  }

  void _resetTextControllers() {
    detailController.clear();
    valueController.clear();
    dateController.text = currentDate();
  }
}
