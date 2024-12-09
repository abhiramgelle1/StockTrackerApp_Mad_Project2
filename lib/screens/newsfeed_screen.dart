import 'package:flutter/material.dart';

class NewsfeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Newsfeed'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text(
          'Newsfeed Content Coming Soon!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
