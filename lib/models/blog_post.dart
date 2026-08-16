import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:intl/intl.dart';

class BlogPost {
  final String id;
  final String title;
  final String date;
  final String excerpt;
  final String content;
  final String category;
  final int timestamp;
  final String? url; // For website articles

  BlogPost({
    required this.id,
    required this.title,
    required this.date,
    required this.excerpt,
    required this.content,
    required this.category,
    required this.timestamp,
    this.url,
  });

  factory BlogPost.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return BlogPost(
      id: doc.id,
      title: data['title'] ?? '',
      date: data['date'] ?? '',
      excerpt: data['excerpt'] ?? '',
      content: data['content'] ?? '',
      category: data['category'] ?? '',
      timestamp: data['timestamp'] ?? 0,
    );
  }

  factory BlogPost.fromRss(RssItem item) {
    // Format date from RSS (usually Wed, 05 Aug 2026 12:00:00 +0000)
    String formattedDate = '';
    int ts = 0;
    try {
      if (item.pubDate != null) {
        // Simple attempt to parse common RSS date format
        DateTime dateTime = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z").parse(item.pubDate!);
        formattedDate = DateFormat("MMM dd, yyyy").format(dateTime);
        ts = int.parse(DateFormat("yyyyMMdd").format(dateTime));
      }
    } catch (e) {
      formattedDate = item.pubDate ?? 'Recent';
    }

    return BlogPost(
      id: item.guid ?? item.link ?? '',
      title: item.title ?? 'No Title',
      date: formattedDate,
      excerpt: item.description ?? '',
      content: item.content?.value ?? item.description ?? '',
      category: 'Website',
      timestamp: ts,
      url: item.link,
    );
  }
}
