import 'package:inovola_flutter_task/features/currency/data/datasources/currency_remote_datasource.dart';

class CurrencyCalculationService {
  final CurrencyRemoteDataSource _currencyRemoteDataSource;

  CurrencyCalculationService({
    required CurrencyRemoteDataSource currencyRemoteDataSource,
  }) : _currencyRemoteDataSource = currencyRemoteDataSource;

  /// Converts an amount from one currency to USD
  ///
  /// [amount] - The amount to convert
  /// [fromCurrency] - The source currency code (e.g., 'EUR', 'GBP')
  /// [toCurrency] - The target currency code (defaults to 'USD')
  ///
  /// Returns the converted amount in USD
  Future<double> convertToUSD({
    required double amount,
    required String fromCurrency,
    String toCurrency = 'USD',
  }) async {
    // If converting from USD to USD, return the same amount
    if (fromCurrency == toCurrency) {
      return amount;
    }

    try {
      // Get exchange rates from the remote data source
      final rates = await _currencyRemoteDataSource.getExchangeRates();

      // Extract the conversion rates from the API response
      final dynamicRates = rates['conversion_rates'] ?? rates['rates'];
      if (dynamicRates is! Map) {
        throw Exception('Invalid rates format from API');
      }

      final conversionRates = (dynamicRates as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, (v as num).toDouble()),
      );

      // Get the exchange rate for the source currency
      final rate = conversionRates[fromCurrency];
      if (rate == null) {
        throw Exception('Exchange rate not found for currency: $fromCurrency');
      }

      if (rate <= 0) {
        throw Exception('Invalid exchange rate for currency: $fromCurrency');
      }

      // Convert the amount to USD
      // Formula: USD amount = original amount / exchange rate
      return amount / rate;
    } catch (e) {
      throw Exception('Failed to convert currency: $e');
    }
  }

  /// Converts an amount from USD to another currency
  ///
  /// [amount] - The amount in USD to convert
  /// [toCurrency] - The target currency code (e.g., 'EUR', 'GBP')
  ///
  /// Returns the converted amount in the target currency
  Future<double> convertFromUSD({
    required double amount,
    required String toCurrency,
  }) async {
    // If converting USD to USD, return the same amount
    if (toCurrency == 'USD') {
      return amount;
    }

    try {
      // Get exchange rates from the remote data source
      final rates = await _currencyRemoteDataSource.getExchangeRates();

      // Extract the conversion rates from the API response
      final dynamicRates = rates['conversion_rates'] ?? rates['rates'];
      if (dynamicRates is! Map) {
        throw Exception('Invalid rates format from API');
      }

      final conversionRates = (dynamicRates as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, (v as num).toDouble()),
      );

      // Get the exchange rate for the target currency
      final rate = conversionRates[toCurrency];
      if (rate == null) {
        throw Exception('Exchange rate not found for currency: $toCurrency');
      }

      if (rate <= 0) {
        throw Exception('Invalid exchange rate for currency: $toCurrency');
      }

      // Convert the amount from USD to target currency
      // Formula: Target currency amount = USD amount * exchange rate
      return amount * rate;
    } catch (e) {
      throw Exception('Failed to convert currency: $e');
    }
  }

  /// Converts an amount between any two currencies
  ///
  /// [amount] - The amount to convert
  /// [fromCurrency] - The source currency code
  /// [toCurrency] - The target currency code
  ///
  /// Returns the converted amount in the target currency
  Future<double> convertCurrency({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    // If same currency, return the same amount
    if (fromCurrency == toCurrency) {
      return amount;
    }

    try {
      // Get exchange rates from the remote data source
      final rates = await _currencyRemoteDataSource.getExchangeRates();

      // Extract the conversion rates from the API response
      final dynamicRates = rates['conversion_rates'] ?? rates['rates'];
      if (dynamicRates is! Map) {
        throw Exception('Invalid rates format from API');
      }

      final conversionRates = (dynamicRates as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, (v as num).toDouble()),
      );

      // Get exchange rates for both currencies
      final fromRate = conversionRates[fromCurrency];
      final toRate = conversionRates[toCurrency];

      if (fromRate == null) {
        throw Exception('Exchange rate not found for currency: $fromCurrency');
      }

      if (toRate == null) {
        throw Exception('Exchange rate not found for currency: $toCurrency');
      }

      if (fromRate <= 0) {
        throw Exception('Invalid exchange rate for currency: $fromCurrency');
      }

      if (toRate <= 0) {
        throw Exception('Invalid exchange rate for currency: $toCurrency');
      }

      // Convert using cross-rate calculation
      // Formula: Target amount = (Original amount / fromRate) * toRate
      return (amount / fromRate) * toRate;
    } catch (e) {
      throw Exception('Failed to convert currency: $e');
    }
  }

  /// Validates if a currency code is supported
  ///
  /// [currencyCode] - The currency code to validate
  ///
  /// Returns true if the currency is supported, false otherwise
  Future<bool> isCurrencySupported(String currencyCode) async {
    try {
      final rates = await _currencyRemoteDataSource.getExchangeRates();
      final dynamicRates = rates['conversion_rates'] ?? rates['rates'];
      if (dynamicRates is! Map) {
        return false;
      }

      final conversionRates = (dynamicRates as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, (v as num).toDouble()),
      );

      return conversionRates.containsKey(currencyCode);
    } catch (e) {
      return false;
    }
  }

  /// Gets the list of supported currencies
  ///
  /// Returns a list of supported currency codes
  Future<List<String>> getSupportedCurrencies() async {
    try {
      final rates = await _currencyRemoteDataSource.getExchangeRates();
      final dynamicRates = rates['conversion_rates'] ?? rates['rates'];
      if (dynamicRates is! Map) {
        return ['USD']; // Fallback to USD only
      }

      final conversionRates = (dynamicRates as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, (v as num).toDouble()),
      );

      return conversionRates.keys.toList();
    } catch (e) {
      return ['USD']; // Fallback to USD only
    }
  }
}
