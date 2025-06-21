import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';
import 'package:inovola_flutter_task/features/expenses/data/datasources/expense_local_datasource.dart';
import 'package:inovola_flutter_task/features/expenses/data/models/expense_model.dart';
import 'package:inovola_flutter_task/features/expenses/domain/usecases/get_expenses.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'expense_local_datasource_test.mocks.dart';

@GenerateMocks([Box])
void main() {
  group('ExpenseLocalDataSource', () {
    late ExpenseLocalDataSourceImpl dataSource;
    late MockBox<ExpenseModel> mockBox;

    setUp(() {
      mockBox = MockBox();
      dataSource = ExpenseLocalDataSourceImpl(box: mockBox);
    });

    group('getExpenses', () {
      test('should return paginated expenses correctly', () async {
        // Arrange
        final expenses = List.generate(
          25,
          (index) => ExpenseModel(
            id: 'expense_$index',
            originalAmount: 100.0,
            originalCurrency: 'USD',
            usdAmount: -100.0,
            date: DateTime.now().subtract(Duration(days: index)),
            category: CategoryType.groceries,
            createdAt: DateTime.now().subtract(Duration(days: index)),
          ),
        );

        when(mockBox.values).thenReturn(expenses);

        // Act
        final result = await dataSource.getExpenses(
          GetExpensesParams(page: 1, pageSize: 10),
        );

        // Assert
        expect(result.length, equals(10));
        expect(result.first.id, equals('expense_0'));
        expect(result.last.id, equals('expense_9'));
      });

      test('should return second page correctly', () async {
        // Arrange
        final expenses = List.generate(
          25,
          (index) => ExpenseModel(
            id: 'expense_$index',
            originalAmount: 100.0,
            originalCurrency: 'USD',
            usdAmount: -100.0,
            date: DateTime.now().subtract(Duration(days: index)),
            category: CategoryType.groceries,
            createdAt: DateTime.now().subtract(Duration(days: index)),
          ),
        );

        when(mockBox.values).thenReturn(expenses);

        // Act
        final result = await dataSource.getExpenses(
          GetExpensesParams(page: 2, pageSize: 10),
        );

        // Assert
        expect(result.length, equals(10));
        expect(result.first.id, equals('expense_10'));
        expect(result.last.id, equals('expense_19'));
      });

      test('should return empty list when page exceeds data', () async {
        // Arrange
        final expenses = List.generate(
          5,
          (index) => ExpenseModel(
            id: 'expense_$index',
            originalAmount: 100.0,
            originalCurrency: 'USD',
            usdAmount: -100.0,
            date: DateTime.now().subtract(Duration(days: index)),
            category: CategoryType.groceries,
            createdAt: DateTime.now().subtract(Duration(days: index)),
          ),
        );

        when(mockBox.values).thenReturn(expenses);

        // Act
        final result = await dataSource.getExpenses(
          GetExpensesParams(page: 3, pageSize: 10),
        );

        // Assert
        expect(result, isEmpty);
      });

      test('should return remaining items on last page', () async {
        // Arrange
        final expenses = List.generate(
          25,
          (index) => ExpenseModel(
            id: 'expense_$index',
            originalAmount: 100.0,
            originalCurrency: 'USD',
            usdAmount: -100.0,
            date: DateTime.now().subtract(Duration(days: index)),
            category: CategoryType.groceries,
            createdAt: DateTime.now().subtract(Duration(days: index)),
          ),
        );

        when(mockBox.values).thenReturn(expenses);

        // Act
        final result = await dataSource.getExpenses(
          GetExpensesParams(page: 3, pageSize: 10),
        );

        // Assert
        expect(result.length, equals(5));
        expect(result.first.id, equals('expense_20'));
        expect(result.last.id, equals('expense_24'));
      });
    });
  });
}
