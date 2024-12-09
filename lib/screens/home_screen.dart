import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock Tracker')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/watchlist'),
            child: Text('Go to Watchlist'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/newsfeed'),
            child: Text('View Newsfeed'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/stock_details'),
            child: Text('Stock Details'),
          ),
        ],
      ),
    );
  }
}
