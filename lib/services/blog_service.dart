import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import '../models/blog_post.dart';
import 'database_service.dart';
import 'dart:async';

class BlogService {
  final String rssUrl = 'https://rbmbusinessholdingsinc.com/feed.xml'; // Verified GoDaddy Airo path

  Future<List<BlogPost>> fetchAllPosts() async {
    List<BlogPost> allPosts = [];

    // 1. Fetch from Firestore
    try {
      // Since streamArticles returns a Stream, we'll convert the first emission to a Future
      final firestorePosts = await DatabaseService().streamArticles().first;
      allPosts.addAll(firestorePosts);
    } catch (e) {
      print('Error fetching Firestore posts: $e');
    }

    // 2. Fetch from Website RSS
    try {
      final response = await http.get(Uri.parse(rssUrl));
      if (response.statusCode == 200) {
        final feed = RssFeed.parse(response.body);
        final rssPosts = feed.items.map((item) => BlogPost.fromRss(item)).toList();
        allPosts.addAll(rssPosts);
      }
    } catch (e) {
      print('Error fetching RSS feed: $e');
    }

    // 3. Sort by timestamp descending
    allPosts.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return allPosts;
  }

  // Stream version for the UI
  Stream<List<BlogPost>> streamAllPosts() {
    return Stream.fromFuture(fetchAllPosts());
  }
}
