import 'package:flutter/material.dart';
import 'package:minimalist_budgetting/controllers/expenses_controller.dart';
import 'package:minimalist_budgetting/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ExpenseController.initialize();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ExpenseController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
