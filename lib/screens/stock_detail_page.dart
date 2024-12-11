import 'package:flutter/material.dart';
import '../services/finnhub_service.dart';

class StockDetailPage extends StatefulWidget {
  final String symbol;

  StockDetailPage({required this.symbol});

  @override
  _StockDetailPageState createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  final FinnhubService _finnhubService = FinnhubService();
  Map<String, dynamic>? _stockData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStockDetails();
  }

  Future<void> _fetchStockDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _finnhubService.fetchStockData(widget.symbol);
      setState(() {
        _stockData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching details for ${widget.symbol}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.symbol} Details'),
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
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _stockData == null
                ? Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Price: \$${_stockData!['c']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'High: \$${_stockData!['h']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Low: \$${_stockData!['l']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Previous Close: \$${_stockData!['pc']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
