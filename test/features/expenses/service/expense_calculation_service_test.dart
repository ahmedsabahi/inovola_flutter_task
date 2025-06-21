import 'package:flutter_test/flutter_test.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';
import 'package:inovola_flutter_task/features/expenses/domain/entities/expense.dart';
import 'package:inovola_flutter_task/features/expenses/service/expense_calculation_service.dart';

void main() {
  group('ExpenseCalculationService', () {
    late ExpenseCalculationService service;
    late List<Expense> testExpenses;

    setUp(() {
      service = ExpenseCalculationService();
      testExpenses = [
        // Income entries (positive amounts)
        Expense(
          originalAmount: 1000,
          originalCurrency: 'USD',
          usdAmount: 1000, // Income
          date: DateTime(2024, 1, 1),
          category: CategoryType.groceries,
          imagePath: null,
        ),
        Expense(
          originalAmount: 500,
          originalCurrency: 'USD',
          usdAmount: 500, // Income
          date: DateTime(2024, 1, 2),
          category: CategoryType.entertainment,
          imagePath: null,
        ),
        // Expense entries (negative amounts)
        Expense(
          originalAmount: 200,
          originalCurrency: 'USD',
          usdAmount: -200, // Expense
          date: DateTime(2024, 1, 3),
          category: CategoryType.gas,
          imagePath: null,
        ),
        Expense(
          originalAmount: 150,
          originalCurrency: 'USD',
          usdAmount: -150, // Expense
          date: DateTime(2024, 1, 4),
          category: CategoryType.shopping,
          imagePath: null,
        ),
        Expense(
          originalAmount: 300,
          originalCurrency: 'USD',
          usdAmount: -300, // Expense
          date: DateTime(2024, 1, 5),
          category: CategoryType.rent,
          imagePath: null,
        ),
      ];
    });

    group('calculateTotalIncome', () {
      test('should calculate total income correctly', () {
        final totalIncome = service.calculateTotalIncome(testExpenses);
        expect(totalIncome, 1500.0); // 1000 + 500
      });

      test('should return 0 for empty list', () {
        final totalIncome = service.calculateTotalIncome([]);
        expect(totalIncome, 0.0);
      });

      test('should return 0 when no income entries exist', () {
        final expensesOnly = testExpenses
            .where((e) => e.usdAmount < 0)
            .toList();
        final totalIncome = service.calculateTotalIncome(expensesOnly);
        expect(totalIncome, 0.0);
      });
    });

    group('calculateTotalExpense', () {
      test('should calculate total expenses correctly', () {
        final totalExpense = service.calculateTotalExpense(testExpenses);
        expect(totalExpense, 650.0); // 200 + 150 + 300
      });

      test('should return 0 for empty list', () {
        final totalExpense = service.calculateTotalExpense([]);
        expect(totalExpense, 0.0);
      });

      test('should return 0 when no expense entries exist', () {
        final incomeOnly = testExpenses.where((e) => e.usdAmount > 0).toList();
        final totalExpense = service.calculateTotalExpense(incomeOnly);
        expect(totalExpense, 0.0);
      });
    });

    group('calculateBalance', () {
      test('should calculate balance correctly (positive)', () {
        final balance = service.calculateBalance(testExpenses);
        expect(balance, 850.0); // 1500 - 650
      });

      test('should calculate balance correctly (negative)', () {
        final negativeBalanceExpenses = [
          Expense(
            originalAmount: 100,
            originalCurrency: 'USD',
            usdAmount: 100, // Income
            date: DateTime(2024, 1, 1),
            category: CategoryType.groceries,
            imagePath: null,
          ),
          Expense(
            originalAmount: 500,
            originalCurrency: 'USD',
            usdAmount: -500, // Expense
            date: DateTime(2024, 1, 2),
            category: CategoryType.entertainment,
            imagePath: null,
          ),
        ];
        final balance = service.calculateBalance(negativeBalanceExpenses);
        expect(balance, -400.0); // 100 - 500
      });

      test('should return 0 for empty list', () {
        final balance = service.calculateBalance([]);
        expect(balance, 0.0);
      });
    });

    group('calculateFinancialSummary', () {
      test('should calculate complete financial summary', () {
        final summary = service.calculateFinancialSummary(testExpenses);

        expect(summary.totalIncome, 1500.0);
        expect(summary.totalExpense, 650.0);
        expect(summary.balance, 850.0);
        expect(summary.totalCount, 5);
        expect(summary.incomeCount, 2);
        expect(summary.expenseCount, 3);
      });

      test('should handle empty list', () {
        final summary = service.calculateFinancialSummary([]);

        expect(summary.totalIncome, 0.0);
        expect(summary.totalExpense, 0.0);
        expect(summary.balance, 0.0);
        expect(summary.totalCount, 0);
        expect(summary.incomeCount, 0);
        expect(summary.expenseCount, 0);
      });

      test('should calculate percentages correctly', () {
        final summary = service.calculateFinancialSummary(testExpenses);

        expect(
          summary.incomePercentage,
          closeTo(69.77, 0.01),
        ); // 1500 / (1500 + 650) * 100
        expect(
          summary.expensePercentage,
          closeTo(30.23, 0.01),
        ); // 650 / (1500 + 650) * 100
      });

      test('should handle zero totals for percentages', () {
        final summary = service.calculateFinancialSummary([]);

        expect(summary.incomePercentage, 0.0);
        expect(summary.expensePercentage, 0.0);
      });
    });

    group('calculateExpensesByCategory', () {
      test('should calculate expenses by category correctly', () {
        final categoryTotals = service.calculateExpensesByCategory(
          testExpenses,
        );

        expect(categoryTotals[CategoryType.gas], 200.0);
        expect(categoryTotals[CategoryType.shopping], 150.0);
        expect(categoryTotals[CategoryType.rent], 300.0);
        expect(
          categoryTotals[CategoryType.groceries],
          null,
        ); // No expenses in groceries
        expect(
          categoryTotals[CategoryType.entertainment],
          null,
        ); // No expenses in entertainment
      });

      test('should return empty map for empty list', () {
        final categoryTotals = service.calculateExpensesByCategory([]);
        expect(categoryTotals, isEmpty);
      });

      test('should return empty map when no expenses exist', () {
        final incomeOnly = testExpenses.where((e) => e.usdAmount > 0).toList();
        final categoryTotals = service.calculateExpensesByCategory(incomeOnly);
        expect(categoryTotals, isEmpty);
      });
    });

    group('calculateMonthlyStatistics', () {
      test('should calculate monthly statistics correctly', () {
        final monthlyStats = service.calculateMonthlyStatistics(testExpenses);

        expect(monthlyStats.length, 1); // All expenses are in January 2024
        expect(monthlyStats.containsKey('2024-01'), true);

        final januarySummary = monthlyStats['2024-01']!;
        expect(januarySummary.totalIncome, 1500.0);
        expect(januarySummary.totalExpense, 650.0);
        expect(januarySummary.balance, 850.0);
        expect(januarySummary.totalCount, 5);
      });

      test('should handle multiple months', () {
        final multiMonthExpenses = [
          ...testExpenses,
          Expense(
            originalAmount: 100,
            originalCurrency: 'USD',
            usdAmount: 100,
            date: DateTime(2024, 2, 1),
            category: CategoryType.groceries,
            imagePath: null,
          ),
        ];

        final monthlyStats = service.calculateMonthlyStatistics(
          multiMonthExpenses,
        );

        expect(monthlyStats.length, 2);
        expect(monthlyStats.containsKey('2024-01'), true);
        expect(monthlyStats.containsKey('2024-02'), true);

        final januarySummary = monthlyStats['2024-01']!;
        final februarySummary = monthlyStats['2024-02']!;

        expect(januarySummary.totalCount, 5);
        expect(februarySummary.totalCount, 1);
        expect(februarySummary.totalIncome, 100.0);
      });

      test('should return empty map for empty list', () {
        final monthlyStats = service.calculateMonthlyStatistics([]);
        expect(monthlyStats, isEmpty);
      });
    });

    group('calculateAverageExpense', () {
      test('should calculate average expense correctly', () {
        final averageExpense = service.calculateAverageExpense(testExpenses);
        expect(averageExpense, closeTo(216.67, 0.01)); // 650 / 3
      });

      test('should return 0 for empty list', () {
        final averageExpense = service.calculateAverageExpense([]);
        expect(averageExpense, 0.0);
      });

      test('should return 0 when no expenses exist', () {
        final incomeOnly = testExpenses.where((e) => e.usdAmount > 0).toList();
        final averageExpense = service.calculateAverageExpense(incomeOnly);
        expect(averageExpense, 0.0);
      });
    });

    group('calculateAverageIncome', () {
      test('should calculate average income correctly', () {
        final averageIncome = service.calculateAverageIncome(testExpenses);
        expect(averageIncome, 750.0); // 1500 / 2
      });

      test('should return 0 for empty list', () {
        final averageIncome = service.calculateAverageIncome([]);
        expect(averageIncome, 0.0);
      });

      test('should return 0 when no income exists', () {
        final expensesOnly = testExpenses
            .where((e) => e.usdAmount < 0)
            .toList();
        final averageIncome = service.calculateAverageIncome(expensesOnly);
        expect(averageIncome, 0.0);
      });
    });
  });

  group('FinancialSummary', () {
    test('should have correct boolean properties', () {
      const positiveSummary = FinancialSummary(
        totalIncome: 1000,
        totalExpense: 500,
        balance: 500,
        totalCount: 5,
        incomeCount: 3,
        expenseCount: 2,
      );

      const negativeSummary = FinancialSummary(
        totalIncome: 500,
        totalExpense: 1000,
        balance: -500,
        totalCount: 5,
        incomeCount: 2,
        expenseCount: 3,
      );

      expect(positiveSummary.isPositive, true);
      expect(positiveSummary.isNegative, false);
      expect(negativeSummary.isPositive, false);
      expect(negativeSummary.isNegative, true);
    });

    test('should calculate percentages correctly', () {
      const summary = FinancialSummary(
        totalIncome: 1000,
        totalExpense: 500,
        balance: 500,
        totalCount: 5,
        incomeCount: 3,
        expenseCount: 2,
      );

      expect(summary.incomePercentage, closeTo(66.67, 0.01));
      expect(summary.expensePercentage, closeTo(33.33, 0.01));
    });

    test('should handle zero totals for percentages', () {
      const summary = FinancialSummary(
        totalIncome: 0,
        totalExpense: 0,
        balance: 0,
        totalCount: 0,
        incomeCount: 0,
        expenseCount: 0,
      );

      expect(summary.incomePercentage, 0.0);
      expect(summary.expensePercentage, 0.0);
    });

    test('should have proper toString method', () {
      const summary = FinancialSummary(
        totalIncome: 1000.50,
        totalExpense: 500.25,
        balance: 500.25,
        totalCount: 5,
        incomeCount: 3,
        expenseCount: 2,
      );

      final string = summary.toString();
      expect(string, contains('totalIncome: \$1000.50'));
      expect(string, contains('totalExpense: \$500.25'));
      expect(string, contains('balance: \$500.25'));
    });

    test('should have proper equality and hashCode', () {
      const summary1 = FinancialSummary(
        totalIncome: 1000,
        totalExpense: 500,
        balance: 500,
        totalCount: 5,
        incomeCount: 3,
        expenseCount: 2,
      );

      const summary2 = FinancialSummary(
        totalIncome: 1000,
        totalExpense: 500,
        balance: 500,
        totalCount: 5,
        incomeCount: 3,
        expenseCount: 2,
      );

      const summary3 = FinancialSummary(
        totalIncome: 1000,
        totalExpense: 500,
        balance: 500,
        totalCount: 5,
        incomeCount: 2, // Different
        expenseCount: 3, // Different
      );

      expect(summary1, equals(summary2));
      expect(summary1.hashCode, equals(summary2.hashCode));
      expect(summary1, isNot(equals(summary3)));
    });
  });
}
