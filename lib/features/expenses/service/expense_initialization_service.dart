import 'package:hive_flutter/hive_flutter.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';
import 'package:inovola_flutter_task/features/expenses/data/models/expense_model.dart';

class ExpenseInitializationService {
  static Future<void> initializeSampleData() async {
    final expenseBox = await Hive.openBox<ExpenseModel>('expenses');
    // Check if we already have data (to avoid adding sample data multiple times)
    if (expenseBox.isNotEmpty) {
      return;
    }

    // Add $70,000 income
    final incomeExpense = ExpenseModel(
      id: 'sample-income-1',
      originalAmount: 70000.0,
      originalCurrency: 'USD',
      usdAmount: 70000.0, // Positive for income
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: CategoryType.transport, // Using a valid category
      imagePath: null,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    );

    await expenseBox.put(incomeExpense.id, incomeExpense);
  }
}
