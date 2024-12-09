import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stocktracker_app_project2/screens/newsfeed_screen.dart';
import 'package:stocktracker_app_project2/screens/stock_details_screen.dart';
import 'package:stocktracker_app_project2/screens/watchlist_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';

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
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/newsfeed': (context) => NewsfeedScreen(),
        '/watchlist': (context) => WatchlistScreen(),
        '/stock_details': (context) => StockDetailsScreen(),
      },
    );
  }
}
