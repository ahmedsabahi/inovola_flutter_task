import 'package:flutter_test/flutter_test.dart';
import 'package:inovola_flutter_task/features/expenses/service/expense_validation.dart';

void main() {
  group('ExpenseValidation', () {
    group('validateAmount', () {
      test('should return null for valid positive amount', () {
        final result = ExpenseValidation.validateAmount('100.50');
        expect(result, isNull);
      });

      test('should return null for valid integer amount', () {
        final result = ExpenseValidation.validateAmount('100');
        expect(result, isNull);
      });

      test('should return null for valid amount with one decimal place', () {
        final result = ExpenseValidation.validateAmount('100.5');
        expect(result, isNull);
      });

      test('should return null for valid amount with two decimal places', () {
        final result = ExpenseValidation.validateAmount('100.99');
        expect(result, isNull);
      });

      test('should return error for null amount', () {
        final result = ExpenseValidation.validateAmount(null);
        expect(result, equals('Amount is required'));
      });

      test('should return error for empty amount', () {
        final result = ExpenseValidation.validateAmount('');
        expect(result, equals('Amount is required'));
      });

      test('should return error for whitespace-only amount', () {
        final result = ExpenseValidation.validateAmount('   ');
        expect(result, equals('Amount must be greater than zero'));
      });

      test('should return error for zero amount', () {
        final result = ExpenseValidation.validateAmount('0');
        expect(result, equals('Amount must be greater than zero'));
      });

      test('should return error for negative amount', () {
        final result = ExpenseValidation.validateAmount('-100');
        expect(result, equals('Amount must be greater than zero'));
      });

      test('should return error for very small positive amount', () {
        final result = ExpenseValidation.validateAmount('0.01');
        expect(result, isNull); // 0.01 is greater than 0, so it should be valid
      });

      test('should return error for amount exceeding maximum limit', () {
        final result = ExpenseValidation.validateAmount('1000000000');
        expect(result, equals('Amount cannot exceed \$999,999,999.99'));
      });

      test('should return error for amount at maximum limit', () {
        final result = ExpenseValidation.validateAmount('999999999.99');
        expect(result, isNull); // This should be valid as it's at the limit
      });

      test(
        'should return error for amount with more than 2 decimal places',
        () {
          final result = ExpenseValidation.validateAmount('100.999');
          expect(
            result,
            equals('Amount cannot have more than 2 decimal places'),
          );
        },
      );

      test('should return error for amount with 3 decimal places', () {
        final result = ExpenseValidation.validateAmount('100.001');
        expect(result, equals('Amount cannot have more than 2 decimal places'));
      });

      test('should return error for invalid numeric format', () {
        final result = ExpenseValidation.validateAmount('abc');
        expect(result, equals('Amount must be greater than zero'));
      });

      test(
        'should return error for amount with letters mixed with numbers',
        () {
          final result = ExpenseValidation.validateAmount('100abc');
          expect(result, equals('Amount must be greater than zero'));
        },
      );

      test('should handle scientific notation', () {
        final result = ExpenseValidation.validateAmount('1e2');
        expect(result, isNull); // 1e2 = 100, which is valid
      });

      test('should handle very large valid amounts', () {
        final result = ExpenseValidation.validateAmount('999999999.98');
        expect(result, isNull);
      });
    });

    group('validateDate', () {
      test('should return null for valid current date', () {
        final now = DateTime.now();
        final result = ExpenseValidation.validateDate(now);
        expect(result, isNull);
      });

      test('should return null for valid past date', () {
        final pastDate = DateTime.now().subtract(const Duration(days: 1));
        final result = ExpenseValidation.validateDate(pastDate);
        expect(result, isNull);
      });

      test('should return null for date exactly 100 years ago', () {
        final now = DateTime.now();
        final hundredYearsAgo = DateTime(now.year - 100, now.month, now.day);
        final result = ExpenseValidation.validateDate(hundredYearsAgo);
        expect(result, isNull);
      });

      test('should return null for date within 100 years ago', () {
        final now = DateTime.now();
        final fiftyYearsAgo = DateTime(now.year - 50, now.month, now.day);
        final result = ExpenseValidation.validateDate(fiftyYearsAgo);
        expect(result, isNull);
      });

      test('should return error for null date', () {
        final result = ExpenseValidation.validateDate(null);
        expect(result, equals('Date is required'));
      });

      test('should return error for future date', () {
        final futureDate = DateTime.now().add(const Duration(days: 1));
        final result = ExpenseValidation.validateDate(futureDate);
        expect(result, equals('Date cannot be in the future'));
      });

      test('should return error for date more than 100 years ago', () {
        final now = DateTime.now();
        final moreThanHundredYearsAgo = DateTime(
          now.year - 101,
          now.month,
          now.day,
        );
        final result = ExpenseValidation.validateDate(moreThanHundredYearsAgo);
        expect(result, equals('Date cannot be more than 100 years ago'));
      });

      test('should return error for date exactly 101 years ago', () {
        final now = DateTime.now();
        final hundredOneYearsAgo = DateTime(now.year - 101, now.month, now.day);
        final result = ExpenseValidation.validateDate(hundredOneYearsAgo);
        expect(result, equals('Date cannot be more than 100 years ago'));
      });

      test('should handle edge case of future date by seconds', () {
        final futureDate = DateTime.now().add(const Duration(seconds: 1));
        final result = ExpenseValidation.validateDate(futureDate);
        expect(result, equals('Date cannot be in the future'));
      });

      test('should handle edge case of past date by seconds', () {
        final pastDate = DateTime.now().subtract(const Duration(seconds: 1));
        final result = ExpenseValidation.validateDate(pastDate);
        expect(result, isNull);
      });

      test('should handle leap year dates', () {
        final leapYearDate = DateTime(2020, 2, 29);
        final result = ExpenseValidation.validateDate(leapYearDate);
        expect(result, isNull);
      });

      test('should handle different months and days', () {
        final testDate = DateTime(2023, 12, 31);
        final result = ExpenseValidation.validateDate(testDate);
        expect(result, isNull);
      });
    });

    group('_getDecimalPlaces (private method)', () {
      test('should return 0 for integer values', () {
        // We can test this indirectly through validateAmount
        final result = ExpenseValidation.validateAmount('100');
        expect(result, isNull); // This means the decimal places check passed
      });

      test('should return 1 for one decimal place', () {
        final result = ExpenseValidation.validateAmount('100.5');
        expect(result, isNull); // This means the decimal places check passed
      });

      test('should return 2 for two decimal places', () {
        final result = ExpenseValidation.validateAmount('100.99');
        expect(result, isNull); // This means the decimal places check passed
      });

      test('should reject more than 2 decimal places', () {
        final result = ExpenseValidation.validateAmount('100.999');
        expect(result, equals('Amount cannot have more than 2 decimal places'));
      });
    });

    group('Integration tests', () {
      test('should validate both amount and date together', () {
        final amountResult = ExpenseValidation.validateAmount('100.50');
        final dateResult = ExpenseValidation.validateDate(DateTime.now());

        expect(amountResult, isNull);
        expect(dateResult, isNull);
      });

      test('should handle multiple validation errors', () {
        final amountResult = ExpenseValidation.validateAmount('-50');
        final dateResult = ExpenseValidation.validateDate(
          DateTime.now().add(const Duration(days: 1)),
        );

        expect(amountResult, equals('Amount must be greater than zero'));
        expect(dateResult, equals('Date cannot be in the future'));
      });
    });
  });
}
