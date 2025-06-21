import 'package:hive/hive.dart';
import 'package:inovola_flutter_task/features/currency/data/models/currency_cache_model.dart';

abstract class CurrencyCacheDataSource {
  Future<CurrencyCacheModel?> getCachedRates();
  Future<void> cacheRates(Map<String, double> rates, String baseCurrency);
  Future<void> clearCache();
}

class CurrencyCacheDataSourceImpl implements CurrencyCacheDataSource {
  final Box<CurrencyCacheModel> box;
  static const String _cacheKey = 'currency_rates_cache';

  CurrencyCacheDataSourceImpl({required this.box});

  @override
  Future<CurrencyCacheModel?> getCachedRates() async {
    try {
      final cached = box.get(_cacheKey);
      if (cached != null && !cached.isExpired && !cached.isEmpty) {
        return cached;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheRates(
    Map<String, double> rates,
    String baseCurrency,
  ) async {
    try {
      final cacheModel = CurrencyCacheModel(
        rates: rates,
        lastUpdated: DateTime.now(),
        baseCurrency: baseCurrency,
      );
      await box.put(_cacheKey, cacheModel);
    } catch (e) {
      // Handle cache write error
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await box.delete(_cacheKey);
    } catch (e) {
      // Handle cache clear error
    }
  }
}
