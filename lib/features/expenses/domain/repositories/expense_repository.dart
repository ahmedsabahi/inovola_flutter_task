import 'package:inovola_flutter_task/features/expenses/domain/entities/expense.dart';
import 'package:inovola_flutter_task/features/expenses/domain/usecases/get_expenses.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getExpenses(GetExpensesParams params);
  Future<void> addExpense(Expense expense);
}
