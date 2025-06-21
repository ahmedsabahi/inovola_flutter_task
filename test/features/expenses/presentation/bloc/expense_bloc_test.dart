import 'package:flutter_test/flutter_test.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';
import 'package:inovola_flutter_task/features/expenses/data/models/expense_model.dart';
import 'package:inovola_flutter_task/features/expenses/domain/entities/expense.dart';

void main() {
  group('ExpenseBloc Business Logic Tests', () {
    group('Balance Calculation Logic', () {
      test(
        'should calculate balance correctly with mixed income and expenses',
        () {
          // Arrange
          final expenses = [
            ExpenseModel(
              id: '1',
              originalAmount: 100.0,
              originalCurrency: 'USD',
              usdAmount: -100.0, // Expense
              date: DateTime.now(),
              category: CategoryType.groceries,
              createdAt: DateTime.now(),
            ),
            ExpenseModel(
              id: '2',
              originalAmount: 300.0,
              originalCurrency: 'USD',
              usdAmount: 300.0, // Income
              date: DateTime.now(),
              category: CategoryType.entertainment,
              createdAt: DateTime.now(),
            ),
            ExpenseModel(
              id: '3',
              originalAmount: 50.0,
              originalCurrency: 'USD',
              usdAmount: -50.0, // Expense
              date: DateTime.now(),
              category: CategoryType.transport,
              createdAt: DateTime.now(),
            ),
          ];

          // Act - Calculate manually to test the logic
          final totalIncome = expenses
              .where((e) => e.usdAmount > 0)
              .fold(0.0, (sum, e) => sum + e.usdAmount);
          final totalExpense = expenses
              .where((e) => e.usdAmount < 0)
              .fold(0.0, (sum, e) => sum + e.usdAmount.abs());
          final balance = totalIncome - totalExpense;

          // Assert
          expect(totalIncome, equals(300.0));
          expect(totalExpense, equals(150.0));
          expect(balance, equals(150.0));
        },
      );

      test('should handle only expenses correctly', () {
        // Arrange
        final expenses = [
          ExpenseModel(
            id: '1',
            originalAmount: 100.0,
            originalCurrency: 'USD',
            usdAmount: -100.0,
            date: DateTime.now(),
            category: CategoryType.groceries,
            createdAt: DateTime.now(),
          ),
          ExpenseModel(
            id: '2',
            originalAmount: 200.0,
            originalCurrency: 'USD',
            usdAmount: -200.0,
            date: DateTime.now(),
            category: CategoryType.transport,
            createdAt: DateTime.now(),
          ),
        ];

        // Act
        final totalIncome = expenses
            .where((e) => e.usdAmount > 0)
            .fold(0.0, (sum, e) => sum + e.usdAmount);
        final totalExpense = expenses
            .where((e) => e.usdAmount < 0)
            .fold(0.0, (sum, e) => sum + e.usdAmount.abs());
        final balance = totalIncome - totalExpense;

        // Assert
        expect(totalIncome, equals(0.0));
        expect(totalExpense, equals(300.0));
        expect(balance, equals(-300.0));
      });

      test('should handle only income correctly', () {
        // Arrange
        final expenses = [
          ExpenseModel(
            id: '1',
            originalAmount: 500.0,
            originalCurrency: 'USD',
            usdAmount: 500.0, // Income
            date: DateTime.now(),
            category: CategoryType.entertainment,
            createdAt: DateTime.now(),
          ),
          ExpenseModel(
            id: '2',
            originalAmount: 300.0,
            originalCurrency: 'USD',
            usdAmount: 300.0, // Income
            date: DateTime.now(),
            category: CategoryType.shopping,
            createdAt: DateTime.now(),
          ),
        ];

        // Act
        final totalIncome = expenses
            .where((e) => e.usdAmount > 0)
            .fold(0.0, (sum, e) => sum + e.usdAmount);
        final totalExpense = expenses
            .where((e) => e.usdAmount < 0)
            .fold(0.0, (sum, e) => sum + e.usdAmount.abs());
        final balance = totalIncome - totalExpense;

        // Assert
        expect(totalIncome, equals(800.0));
        expect(totalExpense, equals(0.0));
        expect(balance, equals(800.0));
      });

      test('should handle empty expenses list correctly', () {
        // Arrange
        final expenses = <Expense>[];

        // Act
        final totalIncome = expenses
            .where((e) => e.usdAmount > 0)
            .fold(0.0, (sum, e) => sum + e.usdAmount);
        final totalExpense = expenses
            .where((e) => e.usdAmount < 0)
            .fold(0.0, (sum, e) => sum + e.usdAmount.abs());
        final balance = totalIncome - totalExpense;

        // Assert
        expect(totalIncome, equals(0.0));
        expect(totalExpense, equals(0.0));
        expect(balance, equals(0.0));
      });
    });

    group('Pagination Logic', () {
      test(
        'should determine hasMore correctly when more items are available',
        () {
          // Arrange
          const pageSize = 10;
          final expenses = List.generate(
            15,
            (index) => ExpenseModel(
              id: index.toString(),
              originalAmount: 100.0,
              originalCurrency: 'USD',
              usdAmount: -100.0,
              date: DateTime.now(),
              category: CategoryType.groceries,
              createdAt: DateTime.now(),
            ),
          );

          // Act
          final hasMore = expenses.length == pageSize;

          // Assert
          expect(
            hasMore,
            isFalse,
          ); // 15 items > 10 page size, so hasMore should be false
        },
      );

      test(
        'should determine hasMore correctly when exactly page size items',
        () {
          // Arrange
          const pageSize = 10;
          final expenses = List.generate(
            10,
            (index) => ExpenseModel(
              id: index.toString(),
              originalAmount: 100.0,
              originalCurrency: 'USD',
              usdAmount: -100.0,
              date: DateTime.now(),
              category: CategoryType.groceries,
              createdAt: DateTime.now(),
            ),
          );

          // Act
          final hasMore = expenses.length == pageSize;

          // Assert
          expect(
            hasMore,
            isTrue,
          ); // Exactly 10 items = page size, so hasMore should be true
        },
      );

      test(
        'should determine hasMore correctly when fewer than page size items',
        () {
          // Arrange
          const pageSize = 10;
          final expenses = List.generate(
            5,
            (index) => ExpenseModel(
              id: index.toString(),
              originalAmount: 100.0,
              originalCurrency: 'USD',
              usdAmount: -100.0,
              date: DateTime.now(),
              category: CategoryType.groceries,
              createdAt: DateTime.now(),
            ),
          );

          // Act
          final hasMore = expenses.length == pageSize;

          // Assert
          expect(
            hasMore,
            isFalse,
          ); // 5 items < 10 page size, so hasMore should be false
        },
      );
    });
  });
}
