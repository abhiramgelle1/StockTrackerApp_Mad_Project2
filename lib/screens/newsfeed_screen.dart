import 'package:flutter/material.dart';
import '../services/finnhub_service.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsfeedScreen extends StatefulWidget {
  @override
  _NewsfeedScreenState createState() => _NewsfeedScreenState();
}

class _NewsfeedScreenState extends State<NewsfeedScreen> {
  final FinnhubService _finnhubService = FinnhubService();
  List<Map<String, dynamic>> _newsArticles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<Map<String, dynamic>> fetchedNews =
          await _finnhubService.fetchNews();
      setState(() {
        _newsArticles = fetchedNews;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching news: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Newsfeed'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.purple.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _newsArticles.isNotEmpty
                  ? ListView.builder(
                      itemCount: _newsArticles.length,
                      itemBuilder: (context, index) {
                        final article = _newsArticles[index];
                        return _buildNewsCard(article);
                      },
                    )
                  : Center(
                      child: Text(
                        'No news available at the moment.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> article) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // News Image or Placeholder
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: article['image'] != null && article['image'].isNotEmpty
                ? Image.network(
                    article['image'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/news_placeholder.png', // Use placeholder image
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Headline
                Text(
                  article['headline'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                // Source
                Text(
                  'Source: ${article['source']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                // Summary
                Text(
                  article['summary'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 8),
                // Read More Button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _openArticle(article['url']);
                    },
                    child: Text('Read More'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openArticle(String url) async {
    final Uri uri = Uri.parse(url);

    try {
      print('Trying to launch URL: $url');
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        print('URL successfully launched');
      } else {
        print('Cannot launch URL: $url');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch the article')),
        );
      }
    } catch (e) {
      print('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening article: $e')),
      );
    }
  }
}
