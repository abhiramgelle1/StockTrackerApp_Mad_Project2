import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/stock_details_screen.dart';
import 'screens/watchlist_screen.dart';
import 'screens/newsfeed_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(StockTrackerApp());
}

class StockTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/stock_details': (context) => StockDetailsScreen(),
        '/watchlist': (context) => WatchlistScreen(),
        '/newsfeed': (context) => NewsfeedScreen(),
      },
    );
  }
}
