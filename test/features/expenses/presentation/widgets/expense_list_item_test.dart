import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';
import 'package:inovola_flutter_task/features/expenses/domain/entities/expense.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/widgets/expense_list_item.dart';

void main() {
  group('ExpenseListItem Widget Tests', () {
    late Expense testExpense;

    setUp(() {
      testExpense = Expense(
        originalAmount: 150.0,
        originalCurrency: 'USD',
        usdAmount: -150.0,
        date: DateTime.now(),
        category: CategoryType.groceries,
      );
    });

    testWidgets('should render expense item with correct structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ExpenseListItem(testExpense))),
      );

      // Verify the main container is present
      expect(find.byType(Container), findsWidgets);

      // Verify category name is displayed
      expect(find.text('Groceries'), findsOneWidget);

      // Verify "Manually" text is displayed
      expect(find.text('Manually'), findsOneWidget);

      // Verify amount is displayed (negative amount)
      expect(find.textContaining('- \$150.00'), findsOneWidget);

      // Verify original currency amount is displayed
      expect(find.textContaining('- USD 150.00'), findsOneWidget);
    });

    testWidgets('should display positive amount correctly', (
      WidgetTester tester,
    ) async {
      final positiveExpense = Expense(
        originalAmount: 200.0,
        originalCurrency: 'EUR',
        usdAmount: 200.0,
        date: DateTime.now(),
        category: CategoryType.entertainment,
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ExpenseListItem(positiveExpense))),
      );

      // Verify positive amount is displayed
      expect(find.textContaining('+ \$200.00'), findsOneWidget);
      expect(find.textContaining('+ EUR 200.00'), findsOneWidget);
    });

    testWidgets('should display category icon correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ExpenseListItem(testExpense))),
      );

      // Verify icon is present
      expect(find.byType(Icon), findsOneWidget);

      // Verify the icon is the correct one for groceries
      final Icon icon = tester.widget(find.byType(Icon));
      expect(icon.icon, equals(CategoryType.groceries.icon));
    });

    testWidgets('should format date correctly for today', (
      WidgetTester tester,
    ) async {
      final todayExpense = Expense(
        originalAmount: 100.0,
        originalCurrency: 'USD',
        usdAmount: -100.0,
        date: DateTime.now(),
        category: CategoryType.groceries,
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ExpenseListItem(todayExpense))),
      );

      // Should display "Today" with time
      expect(find.textContaining('Today'), findsOneWidget);
    });

    testWidgets('should format date correctly for yesterday', (
      WidgetTester tester,
    ) async {
      final yesterdayExpense = Expense(
        originalAmount: 100.0,
        originalCurrency: 'USD',
        usdAmount: -100.0,
        date: DateTime.now().subtract(const Duration(days: 1)),
        category: CategoryType.groceries,
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ExpenseListItem(yesterdayExpense))),
      );

      // Should display "Yesterday" with time
      expect(find.textContaining('Yesterday'), findsOneWidget);
    });

    testWidgets('should format date correctly for other days', (
      WidgetTester tester,
    ) async {
      final otherDayExpense = Expense(
        originalAmount: 100.0,
        originalCurrency: 'USD',
        usdAmount: -100.0,
        date: DateTime(2024, 1, 15),
        category: CategoryType.groceries,
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ExpenseListItem(otherDayExpense))),
      );

      // Should display date in "d MMM" format
      expect(find.textContaining('15 Jan'), findsOneWidget);
    });

    testWidgets('should have correct styling and layout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ExpenseListItem(testExpense))),
      );

      // Verify the container has proper decoration
      final Container container = tester.widget(
        find.ancestor(
          of: find.text('Groceries'),
          matching: find.byType(Container),
        ),
      );

      expect(container.decoration, isNotNull);
      expect(container.margin, isNotNull);
      expect(container.padding, isNotNull);
    });

    testWidgets('should handle different categories correctly', (
      WidgetTester tester,
    ) async {
      final categories = [
        CategoryType.transport,
        CategoryType.entertainment,
        CategoryType.shopping,
        CategoryType.rent,
      ];

      for (final category in categories) {
        final expense = Expense(
          originalAmount: 100.0,
          originalCurrency: 'USD',
          usdAmount: -100.0,
          date: DateTime.now(),
          category: category,
        );

        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: ExpenseListItem(expense))),
        );

        // Verify category name is displayed
        expect(find.text(category.name), findsOneWidget);

        // Verify category icon is displayed
        final Icon icon = tester.widget(find.byType(Icon));
        expect(icon.icon, equals(category.icon));
      }
    });
  });
}
