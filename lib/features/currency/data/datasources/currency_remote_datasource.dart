import 'package:dio/dio.dart';

const String _apiKey = '1399bcb56efe959c843e7f91';
const String _baseUrl =
    'https://v6.exchangerate-api.com/v6/$_apiKey/latest/USD';

abstract class CurrencyRemoteDataSource {
  Future<Map<String, dynamic>> getExchangeRates();
}

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final Dio dio;

  CurrencyRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getExchangeRates() async {
    final response = await dio.get(_baseUrl);
    if (response.statusCode == 200 && response.data['result'] == 'success') {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Failed to fetch exchange rates');
    }
  }
}
