abstract class CurrencyRepository {
  Future<Map<String, double>> getExchangeRates();
}
