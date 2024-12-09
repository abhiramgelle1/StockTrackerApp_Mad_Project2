import 'package:flutter/material.dart';

class NewsfeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Newsfeed')),
      body: Center(
        child: Text('Financial newsfeed appears here.'),
      ),
    );
  }
}
