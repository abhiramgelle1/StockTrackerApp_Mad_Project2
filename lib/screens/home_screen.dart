import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome to Stock Tracker')),
      body: Center(
        child: Text(
          'You are logged in!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
