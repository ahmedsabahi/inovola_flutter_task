import 'package:hive/hive.dart';

part 'currency_cache_model.g.dart';

@HiveType(typeId: 1)
class CurrencyCacheModel extends HiveObject {
  @HiveField(0)
  final Map<String, double> rates;

  @HiveField(1)
  final DateTime lastUpdated;

  @HiveField(2)
  final String baseCurrency;

  CurrencyCacheModel({
    required this.rates,
    required this.lastUpdated,
    required this.baseCurrency,
  });

  bool get isExpired {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);
    // Cache expires after 1 hour
    return difference.inHours >= 1;
  }

  bool get isEmpty => rates.isEmpty;
}
