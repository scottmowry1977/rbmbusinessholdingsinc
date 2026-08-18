import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';
import '../models/blog_post.dart';
import 'database_service.dart';
import 'dart:async';

class BlogService {
  final String rssUrl = 'https://rbmbusinessholdingsinc.com/feed.xml';

  // Fetch from Website RSS
  Future<List<BlogPost>> fetchRssPosts() async {
    try {
      debugPrint('Fetching RSS from: $rssUrl');
      final response = await http.get(Uri.parse(rssUrl)).timeout(const Duration(seconds: 10));
      debugPrint('RSS Status Code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        try {
          final feed = RssFeed.parse(response.body);
          return feed.items.map((item) => BlogPost.fromRss(item)).toList();
        } catch (e) {
          debugPrint('RSS Parse failed, trying Atom: $e');
          final feed = AtomFeed.parse(response.body);
          return feed.items.map((item) => BlogPost.fromAtom(item)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching RSS/Atom feed: $e');
      return []; 
    }
  }

  // Combined Stream of Firestore + RSS
  Stream<List<BlogPost>> streamAllPosts() {
    return Rx.combineLatest2<List<BlogPost>, List<BlogPost>, List<BlogPost>>(
      DatabaseService().streamArticles().handleError((e) {
        debugPrint('Firestore Error: $e');
        return <BlogPost>[];
      }), 
      Stream.fromFuture(fetchRssPosts()).startWith([]).onErrorReturn([]),
      (firestorePosts, rssPosts) {
        final allPosts = [...firestorePosts, ...rssPosts];
        if (allPosts.isEmpty) return [];
        
        allPosts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        return allPosts;
      },
    ).handleError((error) {
      debugPrint('Combined Stream Error: $error');
      return <BlogPost>[];
    });
  }
}
