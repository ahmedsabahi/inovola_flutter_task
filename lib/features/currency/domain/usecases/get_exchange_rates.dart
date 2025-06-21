import '../repositories/currency_repository.dart';

class GetExchangeRates {
  final CurrencyRepository repository;
  GetExchangeRates(this.repository);

  Future<Map<String, double>> call() => repository.getExchangeRates();
}
