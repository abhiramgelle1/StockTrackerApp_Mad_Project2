
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/watchlist_screen.dart';
import 'screens/newsfeed_screen.dart';

void main() {
  runApp(StockTrackerApp());
}

class StockTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/watchlist': (context) => WatchlistScreen(),
        '/newsfeed': (context) => NewsfeedScreen(),
      },
    );
  }
}
