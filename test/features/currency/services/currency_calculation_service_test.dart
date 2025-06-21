import 'package:flutter_test/flutter_test.dart';
import 'package:inovola_flutter_task/features/currency/data/datasources/currency_remote_datasource.dart';
import 'package:inovola_flutter_task/features/currency/services/currency_calculation_service.dart';
import 'package:mockito/mockito.dart';

class MockCurrencyRemoteDataSource extends Mock
    implements CurrencyRemoteDataSource {
  // Mock class for CurrencyRemoteDataSource
  MockCurrencyRemoteDataSource();

  @override
  Future<Map<String, dynamic>> getExchangeRates() {
    // Mock implementation
    return super.noSuchMethod(
      Invocation.method(#getExchangeRates, []),
      returnValue: Future.value({
        'conversion_rates': {'EUR': 0.85, 'GBP': 0.73, 'USD': 1.0},
      }),
    );
  }
}

void main() {
  group('CurrencyCalculationService', () {
    late CurrencyCalculationService currencyCalculationService;
    late MockCurrencyRemoteDataSource mockRemoteDataSource;

    setUp(() {
      mockRemoteDataSource = MockCurrencyRemoteDataSource();
      currencyCalculationService = CurrencyCalculationService(
        currencyRemoteDataSource: mockRemoteDataSource,
      );
    });

    group('convertToUSD', () {
      test('should convert EUR to USD correctly', () async {
        // Arrange
        final rates = {
          'conversion_rates': {'EUR': 0.85, 'GBP': 0.73, 'USD': 1.0},
        };
        when(
          mockRemoteDataSource.getExchangeRates(),
        ).thenAnswer((_) async => rates);
        // Act
        final result = await currencyCalculationService.convertToUSD(
          amount: 100.0,
          fromCurrency: 'EUR',
        );
        // Assert
        expect(result, closeTo(117.65, 0.01));
      });

      test('should return same amount when converting USD to USD', () async {
        // Arrange
        when(
          mockRemoteDataSource.getExchangeRates(),
        ).thenAnswer((_) async => {});
        // Act
        final result = await currencyCalculationService.convertToUSD(
          amount: 100.0,
          fromCurrency: 'USD',
        );
        // Assert
        expect(result, equals(100.0));
      });

      test('should handle GBP to USD conversion', () async {
        // Arrange
        final rates = {
          'conversion_rates': {'EUR': 0.85, 'GBP': 0.73, 'USD': 1.0},
        };
        when(
          mockRemoteDataSource.getExchangeRates(),
        ).thenAnswer((_) async => rates);
        // Act
        final result = await currencyCalculationService.convertToUSD(
          amount: 50.0,
          fromCurrency: 'GBP',
        );
        // Assert
        expect(result, closeTo(68.49, 0.01));
      });

      test('should throw exception for unsupported currency', () async {
        // Arrange
        final rates = {
          'conversion_rates': {'EUR': 0.85, 'USD': 1.0},
        };
        when(
          mockRemoteDataSource.getExchangeRates(),
        ).thenAnswer((_) async => rates);
        // Act & Assert
        expect(
          () => currencyCalculationService.convertToUSD(
            amount: 100.0,
            fromCurrency: 'INVALID',
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception for zero exchange rate', () async {
        // Arrange
        final rates = {
          'conversion_rates': {
            'EUR': 0.0, // Invalid zero rate
            'USD': 1.0,
          },
        };
        when(
          mockRemoteDataSource.getExchangeRates(),
        ).thenAnswer((_) async => rates);
        // Act & Assert
        expect(
          () => currencyCalculationService.convertToUSD(
            amount: 100.0,
            fromCurrency: 'EUR',
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('convertFromUSD', () {
      test('should convert USD to EUR correctly', () async {
        // Arrange
        final rates = {
          'conversion_rates': {'EUR': 0.85, 'GBP': 0.73, 'USD': 1.0},
        };
        when(
          mockRemoteDataSource.getExchangeRates(),
        ).thenAnswer((_) async => rates);
        // Act
        final result = await currencyCalculationService.convertFromUSD(
          amount: 100.0,
          toCurrency: 'EUR',
        );
        // Assert
        expect(result, equals(85.0));
      });

      test('should return same amount when converting USD to USD', () async {
        // Arrange
        when(
          mockRemoteDataSource.getExchangeRates(),
        ).thenAnswer((_) async => {});
        // Act
        final result = await currencyCalculationService.convertFromUSD(
          amount: 100.0,
          toCurrency: 'USD',
        );
        // Assert
        expect(result, equals(100.0));
      });
    });

    group('convertCurrency', () {
      test('should convert EUR to GBP correctly', () async {
        // Arrange
        final rates = {
          'conversion_rates': {'EUR': 0.85, 'GBP': 0.73, 'USD': 1.0},
        };
        when(
          mockRemoteDataSource.getExchangeRates(),
        ).thenAnswer((_) async => rates);
        // Act
        final result = await currencyCalculationService.convertCurrency(
          amount: 100.0,
          fromCurrency: 'EUR',
          toCurrency: 'GBP',
        );
        // Assert
        expect(result, closeTo(85.88, 0.01));
      });

      test('should return same amount when converting same currency', () async {
        // Arrange
        when(
          mockRemoteDataSource.getExchangeRates(),
        ).thenAnswer((_) async => {});
        // Act
        final result = await currencyCalculationService.convertCurrency(
          amount: 100.0,
          fromCurrency: 'EUR',
          toCurrency: 'EUR',
        );
        // Assert
        expect(result, equals(100.0));
      });
    });

    group('isCurrencySupported', () {
      test('should return true for supported currency', () async {
        // Arrange
        final rates = {
          'conversion_rates': {'EUR': 0.85, 'GBP': 0.73, 'USD': 1.0},
        };
        when(
          mockRemoteDataSource.getExchangeRates(),
        ).thenAnswer((_) async => rates);
        // Act
        final result = await currencyCalculationService.isCurrencySupported(
          'EUR',
        );
        // Assert
        expect(result, isTrue);
      });

      test('should return false for unsupported currency', () async {
        // Arrange
        final rates = {
          'conversion_rates': {'EUR': 0.85, 'USD': 1.0},
        };
        when(
          mockRemoteDataSource.getExchangeRates(),
        ).thenAnswer((_) async => rates);
        // Act
        final result = await currencyCalculationService.isCurrencySupported(
          'INVALID',
        );
        // Assert
        expect(result, isFalse);
      });

      test('should return false when API fails', () async {
        // Arrange
        when(
          mockRemoteDataSource.getExchangeRates(),
        ).thenThrow(Exception('API Error'));
        // Act
        final result = await currencyCalculationService.isCurrencySupported(
          'EUR',
        );
        // Assert
        expect(result, isFalse);
      });
    });

    group('getSupportedCurrencies', () {
      test('should return list of supported currencies', () async {
        // Arrange
        final rates = {
          'conversion_rates': {
            'EUR': 0.85,
            'GBP': 0.73,
            'USD': 1.0,
            'JPY': 110.0,
          },
        };
        when(
          mockRemoteDataSource.getExchangeRates(),
        ).thenAnswer((_) async => rates);
        // Act
        final result = await currencyCalculationService
            .getSupportedCurrencies();
        // Assert
        expect(result, containsAll(['EUR', 'GBP', 'USD', 'JPY']));
        expect(result.length, equals(4));
      });

      test('should return USD only when API fails', () async {
        // Arrange
        when(
          mockRemoteDataSource.getExchangeRates(),
        ).thenThrow(Exception('API Error'));
        // Act
        final result = await currencyCalculationService
            .getSupportedCurrencies();
        // Assert
        expect(result, equals(['USD']));
      });
    });
  });
}
