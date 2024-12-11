import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/finnhub_service.dart';

class StockDetailsScreen extends StatefulWidget {
  final String? initialSymbol;

  StockDetailsScreen({this.initialSymbol});

  @override
  _StockDetailsScreenState createState() => _StockDetailsScreenState();
}

class _StockDetailsScreenState extends State<StockDetailsScreen> {
  final TextEditingController _stockSymbolController = TextEditingController();
  final FinnhubService _finnhubService = FinnhubService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  final List<String> _defaultStocks = ['AAPL', 'GOOGL', 'MSFT', 'AMZN', 'TSLA'];
  Map<String, Map<String, dynamic>> _stockData = {};
  Set<String> _watchlist = {};

  @override
  void initState() {
    super.initState();
    _fetchWatchlist();

    if (widget.initialSymbol != null) {
      _fetchStockDetails(widget.initialSymbol!);
    } else {
      _fetchDefaultStocks();
    }
  }

  // Fetch Watchlist
  Future<void> _fetchWatchlist() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      final snapshot = await _firestore
          .collection('watchlists')
          .doc(userId)
          .collection('stocks')
          .get();

      setState(() {
        _watchlist =
            snapshot.docs.map((doc) => doc['symbol'] as String).toSet();
      });
    } catch (e) {
      print('Error fetching watchlist: $e');
    }
  }

  // Fetch Default Stocks
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
        print('Error fetching data for $symbol: $e');
      }
    }

    setState(() {
      _stockData = fetchedData;
      _isLoading = false;
    });
  }

  // Fetch Specific Stock
  Future<void> _fetchStockDetails(String symbol) async {
    if (symbol.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a stock symbol')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _stockData = {}; // Clear previous data
    });

    try {
      final data =
          await _finnhubService.fetchStockData(symbol.trim().toUpperCase());
      setState(() {
        _stockData = {symbol: data}; // Display only searched stock
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

  // Toggle Watchlist
  Future<void> _toggleWatchlist(String symbol) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      final watchlistRef =
          _firestore.collection('watchlists').doc(userId).collection('stocks');

      if (_watchlist.contains(symbol)) {
        final existingStock =
            await watchlistRef.where('symbol', isEqualTo: symbol).get();
        for (var doc in existingStock.docs) {
          await doc.reference.delete();
        }

        setState(() {
          _watchlist.remove(symbol);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$symbol removed from watchlist')),
        );
      } else {
        await watchlistRef.add({'symbol': symbol});
        setState(() {
          _watchlist.add(symbol);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$symbol added to watchlist')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating watchlist: $e')),
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
                      _fetchStockDetails(_stockSymbolController.text.trim());
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Display Loading Indicator or Stock Data
              _isLoading
                  ? CircularProgressIndicator()
                  : _stockData.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: _stockData.keys.length,
                            itemBuilder: (context, index) {
                              final symbol = _stockData.keys.elementAt(index);
                              final data = _stockData[symbol];
                              return _buildStockCard(symbol, data);
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            'No stock data available.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
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
              'assets/stock_image.png', // Placeholder image for stock
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(color: Colors.grey),
                _buildStockDetailRow('Current Price', '\$${data['c']}'),
                _buildStockDetailRow('High Price', '\$${data['h']}'),
                _buildStockDetailRow('Low Price', '\$${data['l']}'),
                _buildStockDetailRow('Previous Close', '\$${data['pc']}'),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        _watchlist.contains(symbol)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: _watchlist.contains(symbol)
                            ? Colors.red
                            : Colors.grey,
                        size: 30,
                      ),
                      onPressed: () => _toggleWatchlist(symbol),
                    ),
                    Text(
                      _watchlist.contains(symbol)
                          ? 'Added to Watchlist'
                          : 'Add to Watchlist',
                      style: TextStyle(
                        fontSize: 16,
                        color: _watchlist.contains(symbol)
                            ? Colors.green
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
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
