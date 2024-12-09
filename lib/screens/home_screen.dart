import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();
      setState(() {
        userDetails = doc.data();
      });
    } catch (e) {
      print('Failed to fetch user details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Genius'),
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      userDetails?['username'] ?? "User",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.email, color: Colors.white),
                title: Text(
                  'Email',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  userDetails?['email'] ?? "N/A",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ListTile(
                leading: Icon(Icons.phone, color: Colors.white),
                title: Text(
                  'Phone',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  userDetails?['phone'] ?? "N/A",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              Divider(color: Colors.white54),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.redAccent),
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.teal.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Logo
              Center(
                child: Image.asset(
                  'assets/appLogo.png',
                  height: 100,
                  width: 100,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Welcome to Stock Genius",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                  ),
                  children: [
                    _buildNavigationCard(
                      title: "Newsfeed",
                      icon: Icons.article,
                      color: Colors.blueAccent,
                      onTap: () => Navigator.pushNamed(context, '/newsfeed'),
                    ),
                    _buildNavigationCard(
                      title: "Watchlist",
                      icon: Icons.list,
                      color: Colors.greenAccent,
                      onTap: () => Navigator.pushNamed(context, '/watchlist'),
                    ),
                    _buildNavigationCard(
                      title: "Stock Details",
                      icon: Icons.bar_chart,
                      color: Colors.orangeAccent,
                      onTap: () =>
                          Navigator.pushNamed(context, '/stock_details'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
