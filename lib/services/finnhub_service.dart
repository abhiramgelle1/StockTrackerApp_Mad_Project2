import 'dart:convert';
import 'package:http/http.dart' as http;

class FinnhubService {
  final String apiKey = 'ctbm2dhr01qvslqusgv0ctbm2dhr01qvslqusgvg';

  Future<Map<String, dynamic>> fetchStockData(String symbol) async {
    final url = Uri.parse(
        'https://finnhub.io/api/v1/quote?symbol=$symbol&token=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load stock data');
    }
  }
}
