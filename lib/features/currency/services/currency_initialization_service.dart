import 'package:flutter/cupertino.dart';
import 'package:inovola_flutter_task/core/di/injection_container.dart';
import 'package:inovola_flutter_task/features/currency/domain/usecases/get_exchange_rates.dart';

class CurrencyInitializationService {
  static Future<void> initializeCurrencies() async {
    try {
      // This will trigger the cache/API logic in the repository
      final getExchangeRates = sl<GetExchangeRates>();
      await getExchangeRates();
    } catch (e) {
      // Log error but don't crash the app
      debugPrint('Failed to initialize currencies: $e');
    }
  }
}
