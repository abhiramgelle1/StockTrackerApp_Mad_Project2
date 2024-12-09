import 'package:flutter/material.dart';

class WatchlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text(
          'Your Watchlist Content Here!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
