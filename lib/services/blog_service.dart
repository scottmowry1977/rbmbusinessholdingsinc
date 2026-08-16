import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import 'package:rxdart/rxdart.dart';
import '../models/blog_post.dart';
import 'database_service.dart';
import 'dart:async';

class BlogService {
  final String rssUrl = 'https://rbmbusinessholdingsinc.com/feed.xml';

  // Fetch from Website RSS
  Future<List<BlogPost>> fetchRssPosts() async {
    try {
      print('Fetching RSS from: $rssUrl');
      final response = await http.get(Uri.parse(rssUrl));
      print('RSS Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('RSS Body length: ${response.body.length}');
        // Try parsing as RSS
        try {
          final feed = RssFeed.parse(response.body);
          print('Found ${feed.items.length} RSS items');
          return feed.items.map((item) => BlogPost.fromRss(item)).toList();
        } catch (e) {
          print('RSS Parse failed, trying Atom: $e');
          // If RSS fails, try Atom
          final feed = AtomFeed.parse(response.body);
          print('Found ${feed.items.length} Atom items');
          return feed.items.map((item) => BlogPost.fromAtom(item)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching RSS/Atom feed: $e');
      return [];
    }
  }

  // Combined Stream of Firestore + RSS
  Stream<List<BlogPost>> streamAllPosts() {
    // Combine Firestore stream with a stream from the RSS Future
    return CombineLatestStream.combine2<List<BlogPost>, List<BlogPost>, List<BlogPost>>(
      DatabaseService().streamArticles(), // Live Firestore stream (no .first)
      Stream.fromFuture(fetchRssPosts()), // RSS fetch
      (firestorePosts, rssPosts) {
        final allPosts = [...firestorePosts, ...rssPosts];
        // Sort by timestamp descending
        allPosts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        return allPosts;
      },
    );
  }
}
