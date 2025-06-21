import 'package:inovola_flutter_task/features/expenses/domain/entities/expense.dart';
import 'package:inovola_flutter_task/features/expenses/domain/repositories/expense_repository.dart';

class AddExpense {
  final ExpenseRepository repository;

  AddExpense(this.repository);

  Future<void> call(Expense expense) async {
    return await repository.addExpense(expense);
  }
}
