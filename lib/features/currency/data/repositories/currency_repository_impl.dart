import '../../domain/repositories/currency_repository.dart';
import '../datasources/currency_cache_datasource.dart';
import '../datasources/currency_remote_datasource.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;
  final CurrencyCacheDataSource cacheDataSource;

  CurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheDataSource,
  });

  @override
  Future<Map<String, double>> getExchangeRates() async {
    try {
      // First, try to get cached rates
      final cachedRates = await cacheDataSource.getCachedRates();
      if (cachedRates != null &&
          !cachedRates.isExpired &&
          !cachedRates.isEmpty) {
        return cachedRates.rates;
      }

      // If no cache or expired, fetch from API
      final rawRates = await remoteDataSource.getExchangeRates();
      final dynamicRates = rawRates['conversion_rates'] ?? rawRates['rates'];
      if (dynamicRates is! Map) {
        throw Exception('Invalid rates format from API');
      }
      final rates = (dynamicRates as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, (v as num).toDouble()),
      );

      // Cache the new rates
      await cacheDataSource.cacheRates(rates, 'USD');

      return rates;
    } catch (e) {
      // If API fails, try to get expired cache as fallback
      final cachedRates = await cacheDataSource.getCachedRates();
      if (cachedRates != null && !cachedRates.isEmpty) {
        return cachedRates.rates;
      }

      // If no cache at all, rethrow the error
      throw Exception('Failed to fetch exchange rates: $e');
    }
  }
}
