import 'package:flutter/material.dart';
import '../services/finnhub_service.dart';

class StockDetailsScreen extends StatefulWidget {
  @override
  _StockDetailsScreenState createState() => _StockDetailsScreenState();
}

class _StockDetailsScreenState extends State<StockDetailsScreen> {
  final TextEditingController _stockSymbolController = TextEditingController();
  final FinnhubService _finnhubService = FinnhubService();
  bool _isLoading = false;

  // Default stock symbols
  final List<String> _defaultStocks = ['AAPL', 'GOOGL', 'MSFT', 'AMZN', 'TSLA'];
  Map<String, Map<String, dynamic>> _stockData = {};

  @override
  void initState() {
    super.initState();
    _fetchDefaultStocks();
  }

  // Fetch data for default stocks
  Future<void> _fetchDefaultStocks() async {
    setState(() {
      _isLoading = true;
    });

    Map<String, Map<String, dynamic>> fetchedData = {};
    for (String symbol in _defaultStocks) {
      try {
        final data = await _finnhubService.fetchStockData(symbol);
        fetchedData[symbol] = data;
      } catch (e) {
        // Handle errors for individual stocks
        print('Error fetching data for $symbol: $e');
      }
    }

    setState(() {
      _stockData = fetchedData;
      _isLoading = false;
    });
  }

  // Fetch data for a specific stock
  Future<void> _fetchStockDetails(String symbol) async {
    setState(() {
      _isLoading = true;
      _stockData = {}; // Clear previous results
    });

    try {
      final data = await _finnhubService.fetchStockData(symbol);
      setState(() {
        _stockData[symbol] = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data for $symbol: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Details'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.purple.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _stockSymbolController,
                decoration: InputDecoration(
                  labelText: 'Enter Stock Symbol (e.g., AAPL)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.teal),
                    onPressed: () {
                      if (_stockSymbolController.text.isNotEmpty) {
                        _fetchStockDetails(_stockSymbolController.text.trim());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Please enter a stock symbol')),
                        );
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Loading Indicator or Stock Data
              _isLoading
                  ? CircularProgressIndicator()
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _stockData.keys.length,
                        itemBuilder: (context, index) {
                          final symbol = _stockData.keys.elementAt(index);
                          final data = _stockData[symbol];
                          return _buildStockCard(symbol, data);
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockCard(String symbol, Map<String, dynamic>? data) {
    if (data == null) return SizedBox.shrink();

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.black87,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stock Image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.asset(
              'assets/stock_image.png', // Placeholder graph image
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stock Symbol
                Text(
                  symbol,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Divider(color: Colors.white54),
                _buildStockDetailRow('Current Price', '\$${data['c']}'),
                _buildStockDetailRow('High Price', '\$${data['h']}'),
                _buildStockDetailRow('Low Price', '\$${data['l']}'),
                _buildStockDetailRow('Previous Close', '\$${data['pc']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
