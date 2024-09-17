import 'package:flutter/material.dart';
import 'package:minimalist_budgetting/bar_graph/bar_graph.dart';
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

  Future<Map<String,double>>? _monthlyTotalsFuture;
  Future<double>? _calculateCurrentMonthlyTotal;

  @override
  void initState() {
    Provider.of<ExpenseController>(context, listen: false).list();

    refreshData();

    super.initState();
  }

  void refreshData() {
    _monthlyTotalsFuture = Provider.of<ExpenseController>(context, listen: false).calculateMonthlyTotals();
    _calculateCurrentMonthlyTotal = Provider.of<ExpenseController>(context, listen: false).calculateCurrentMonthTotal();
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
      builder: (context, value, child) {
        DateTime startDateTime = value.startDateTime();
        DateTime now = DateTime.now();

        int monthCount = calculateMonthCount(now, startDateTime);

        List<Expense> currentMonthExpenses = value.expenses.where((expense) {
          return expense.date.year == now.year && expense.date.month == now.month;
        }).toList();

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: openNewExpenseBox,
            backgroundColor: Colors.grey[800],
            child: const Icon(Icons.add, color: Colors.white),
          ),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: FutureBuilder<double>(
              future: _calculateCurrentMonthlyTotal, 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(currentMonthName),
                      Text('\$${snapshot.data!.toStringAsFixed(2)}'),
                    ],
                  );
                }

                return const Text("Loading...");
              },
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 250,
                  child: FutureBuilder(
                    future: _monthlyTotalsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String,double> monthlyTotals = snapshot.data ?? {};
                  
                        List<double> monthlySummary = List.generate(monthCount, (index) {
                          int year = startDateTime.year + (startDateTime.month + index - 1) ~/ 12;
                          int month = (startDateTime.month + index - 1) % 12 + 1;

                          String yearMonthKey = '$year-$month';

                          return monthlyTotals[yearMonthKey] ?? 0.0;
                        });
                  
                        return BarGraph(monthlySummary: monthlySummary, startMonth: startDateTime.month);
                      }
                  
                      return const Center(child: Text("Loading"));
                    }
                  ),
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: ListView.builder(
                          itemCount: currentMonthExpenses.length,
                          itemBuilder: (context, index) {
                            int reversedIndex = currentMonthExpenses.length - 1 - index;

                            Expense expense = currentMonthExpenses[reversedIndex];
                            return ExpenseTile(
                              title: expense.detail,
                              value: formatValue(expense.value),
                              onDeletePressed: (context) => openDeleteBox(expense),
                              onEditPressed: (context) => openEditBox(expense),
                            );
                          },
                        ),
                ),
              ]
            ),
          )
        );
      }
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

          refreshData();
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

          refreshData();
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
        refreshData();
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
