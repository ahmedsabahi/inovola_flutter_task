import 'package:hive/hive.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';
import 'package:inovola_flutter_task/features/expenses/data/models/expense_model.dart';
import 'package:inovola_flutter_task/features/expenses/domain/usecases/get_expenses.dart';

abstract class ExpenseLocalDataSource {
  Future<List<ExpenseModel>> getExpenses(GetExpensesParams params);
  Future<void> addExpense(ExpenseModel expense);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final Box<ExpenseModel> box;

  ExpenseLocalDataSourceImpl({required this.box});

  @override
  Future<List<ExpenseModel>> getExpenses(GetExpensesParams params) async {
    List<ExpenseModel> all = box.values.toList();
    // Filtering
    if (params.from != null) {
      all = all
          .where(
            (e) => e.date.isAfter(
              params.from!.subtract(const Duration(microseconds: 1)),
            ),
          )
          .toList();
    }
    if (params.to != null) {
      all = all
          .where(
            (e) => e.date.isBefore(
              params.to!.add(const Duration(microseconds: 1)),
            ),
          )
          .toList();
    }
    if (params.category != null) {
      all = all.where((e) => e.category.name == params.category).toList();
    }

    // Sort by creation time descending (newest first)
    all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    // Pagination
    final start = (params.page - 1) * params.pageSize;
    final end = start + params.pageSize;
    if (start >= all.length) return [];
    return all.sublist(start, end > all.length ? all.length : end);
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await box.put(expense.id, expense);
  }
}
