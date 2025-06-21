import 'package:inovola_flutter_task/features/expenses/domain/entities/expense.dart';
import 'package:inovola_flutter_task/features/expenses/domain/repositories/expense_repository.dart';

class GetExpensesParams {
  final int page;
  final int pageSize;
  final DateTime? from;
  final DateTime? to;
  final String? category;

  GetExpensesParams({
    required this.page,
    required this.pageSize,
    this.from,
    this.to,
    this.category,
  });
}

class GetExpenses {
  final ExpenseRepository repository;

  GetExpenses(this.repository);

  Future<List<Expense>> call(GetExpensesParams params) async {
    return await repository.getExpenses(params);
  }
}
