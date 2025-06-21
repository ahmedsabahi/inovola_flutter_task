import 'package:inovola_flutter_task/core/constants/category_enum.dart';
import 'package:inovola_flutter_task/features/expenses/domain/entities/expense.dart';

/// Service responsible for calculating financial metrics and statistics
/// from a collection of expenses
class ExpenseCalculationService {
  /// Calculates total income from all expenses
  /// Returns the sum of all positive USD amounts
  double calculateTotalIncome(List<Expense> expenses) {
    return expenses
        .where((expense) => expense.usdAmount > 0)
        .fold(0.0, (sum, expense) => sum + expense.usdAmount);
  }

  /// Calculates total expenses from all expenses
  /// Returns the sum of all negative USD amounts (as positive values)
  double calculateTotalExpense(List<Expense> expenses) {
    return expenses
        .where((expense) => expense.usdAmount < 0)
        .fold(0.0, (sum, expense) => sum + expense.usdAmount.abs());
  }

  /// Calculates the balance (total income - total expenses)
  /// Returns the net balance in USD
  double calculateBalance(List<Expense> expenses) {
    final totalIncome = calculateTotalIncome(expenses);
    final totalExpense = calculateTotalExpense(expenses);
    return totalIncome - totalExpense;
  }

  /// Calculates all financial metrics for the given expenses
  /// Returns a comprehensive financial summary
  FinancialSummary calculateFinancialSummary(List<Expense> expenses) {
    final totalIncome = calculateTotalIncome(expenses);
    final totalExpense = calculateTotalExpense(expenses);
    final balance = totalIncome - totalExpense;

    return FinancialSummary(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      balance: balance,
      totalCount: expenses.length,
      incomeCount: expenses.where((e) => e.usdAmount > 0).length,
      expenseCount: expenses.where((e) => e.usdAmount < 0).length,
    );
  }

  /// Calculates expenses by category
  /// Returns a map of category to total amount
  Map<CategoryType, double> calculateExpensesByCategory(
    List<Expense> expenses,
  ) {
    final Map<CategoryType, double> categoryTotals = {};

    for (final expense in expenses) {
      if (expense.usdAmount < 0) {
        // Only expenses, not income
        final currentTotal = categoryTotals[expense.category] ?? 0.0;
        categoryTotals[expense.category] =
            currentTotal + expense.usdAmount.abs();
      }
    }

    return categoryTotals;
  }

  /// Calculates monthly statistics
  /// Returns a map of year-month to financial summary
  Map<String, FinancialSummary> calculateMonthlyStatistics(
    List<Expense> expenses,
  ) {
    final Map<String, List<Expense>> monthlyExpenses = {};

    for (final expense in expenses) {
      final yearMonth =
          '${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}';
      monthlyExpenses.putIfAbsent(yearMonth, () => []).add(expense);
    }

    return monthlyExpenses.map(
      (yearMonth, monthExpenses) =>
          MapEntry(yearMonth, calculateFinancialSummary(monthExpenses)),
    );
  }

  /// Calculates average expense amount
  double calculateAverageExpense(List<Expense> expenses) {
    final expenseList = expenses.where((e) => e.usdAmount < 0).toList();
    if (expenseList.isEmpty) return 0.0;

    final totalExpense = calculateTotalExpense(expenses);
    return totalExpense / expenseList.length;
  }

  /// Calculates average income amount
  double calculateAverageIncome(List<Expense> expenses) {
    final incomeList = expenses.where((e) => e.usdAmount > 0).toList();
    if (incomeList.isEmpty) return 0.0;

    final totalIncome = calculateTotalIncome(expenses);
    return totalIncome / incomeList.length;
  }
}

/// Value object representing a comprehensive financial summary
class FinancialSummary {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final int totalCount;
  final int incomeCount;
  final int expenseCount;

  const FinancialSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.totalCount,
    required this.incomeCount,
    required this.expenseCount,
  });

  /// Returns true if the balance is positive
  bool get isPositive => balance > 0;

  /// Returns true if the balance is negative
  bool get isNegative => balance < 0;

  /// Returns the percentage of income vs expenses
  double get incomePercentage {
    if (totalIncome == 0 && totalExpense == 0) return 0.0;
    return (totalIncome / (totalIncome + totalExpense)) * 100;
  }

  /// Returns the percentage of expenses vs total
  double get expensePercentage {
    if (totalIncome == 0 && totalExpense == 0) return 0.0;
    return (totalExpense / (totalIncome + totalExpense)) * 100;
  }

  @override
  String toString() {
    return 'FinancialSummary(totalIncome: \$${totalIncome.toStringAsFixed(2)}, '
        'totalExpense: \$${totalExpense.toStringAsFixed(2)}, '
        'balance: \$${balance.toStringAsFixed(2)})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FinancialSummary &&
        other.totalIncome == totalIncome &&
        other.totalExpense == totalExpense &&
        other.balance == balance &&
        other.totalCount == totalCount &&
        other.incomeCount == incomeCount &&
        other.expenseCount == expenseCount;
  }

  @override
  int get hashCode {
    return Object.hash(
      totalIncome,
      totalExpense,
      balance,
      totalCount,
      incomeCount,
      expenseCount,
    );
  }
}
