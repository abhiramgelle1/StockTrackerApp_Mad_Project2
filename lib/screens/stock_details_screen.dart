import 'package:flutter/material.dart';

class StockDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text(
          'Stock Details Content Coming Soon!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
