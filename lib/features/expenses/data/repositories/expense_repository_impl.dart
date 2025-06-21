import 'package:inovola_flutter_task/features/expenses/data/datasources/expense_local_datasource.dart';
import 'package:inovola_flutter_task/features/expenses/data/models/expense_model.dart';
import 'package:inovola_flutter_task/features/expenses/domain/entities/expense.dart';
import 'package:inovola_flutter_task/features/expenses/domain/repositories/expense_repository.dart';
import 'package:inovola_flutter_task/features/expenses/domain/usecases/get_expenses.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Expense>> getExpenses(GetExpensesParams params) async {
    final expenses = await localDataSource.getExpenses(params);
    return expenses;
  }

  @override
  Future<void> addExpense(Expense expense) async {
    await localDataSource.addExpense(ExpenseModel.fromEntity(expense));
  }
}
