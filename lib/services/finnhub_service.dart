import 'dart:convert';
import 'package:http/http.dart' as http;

class FinnhubService {
  final String apiKey = 'ctbm2dhr01qvslqusgv0ctbm2dhr01qvslqusgvg';

  // Fetch stock data
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

  // Fetch financial news
  Future<List<Map<String, dynamic>>> fetchNews() async {
    final url = Uri.parse(
        'https://finnhub.io/api/v1/news?category=general&token=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data
          .map((article) => {
                'headline': article['headline'],
                'source': article['source'],
                'summary': article['summary'],
                'url': article['url'],
                'image': article['image'],
              })
          .toList();
    } else {
      throw Exception('Failed to fetch news');
    }
  }
}
