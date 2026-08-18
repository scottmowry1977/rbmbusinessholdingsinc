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
    
    // Safety check for timestamp which could be an int (YYYYMMDD) or a Firestore Timestamp
    int ts = 0;
    DateTime? derivedDateTime;

    if (data['timestamp'] != null) {
      if (data['timestamp'] is int) {
        ts = data['timestamp'];
        // Try to derive a DateTime for the display string if needed
        try {
          String s = ts.toString();
          if (s.length == 8) {
            derivedDateTime = DateTime(
              int.parse(s.substring(0, 4)),
              int.parse(s.substring(4, 6)),
              int.parse(s.substring(6, 8)),
            );
          }
        } catch (_) {}
      } else if (data['timestamp'] is Timestamp) {
        final DateTime dt = (data['timestamp'] as Timestamp).toDate();
        derivedDateTime = dt;
        // Convert to YYYYMMDD for unified sorting
        ts = int.parse("${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}");
      }
    }

    // If 'date' string is missing, format it from the timestamp
    String displayDate = data['date'] ?? '';
    if (displayDate.isEmpty && derivedDateTime != null) {
      displayDate = DateFormat("MMM dd, yyyy").format(derivedDateTime);
    }

    return BlogPost(
      id: doc.id,
      title: data['title'] ?? '',
      date: displayDate.isEmpty ? 'Recent' : displayDate,
      excerpt: data['excerpt'] ?? '',
      content: data['content'] ?? '',
      category: data['category'] ?? '',
      timestamp: ts,
    );
  }

  factory BlogPost.fromRss(RssItem item) {
    // Format date from RSS (usually Wed, 05 Aug 2026 12:00:00 +0000)
    String formattedDate = '';
    int ts = 0;
    try {
      if (item.pubDate != null) {
        // Try various date formats common in RSS
        DateTime? dateTime;
        try {
          dateTime = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z").parse(item.pubDate!);
        } catch (_) {
          try {
            dateTime = DateFormat("EEE, dd MMM yyyy HH:mm:ss zzz").parse(item.pubDate!);
          } catch (_) {
            dateTime = DateTime.tryParse(item.pubDate!);
          }
        }
        
        if (dateTime != null) {
          formattedDate = DateFormat("MMM dd, yyyy").format(dateTime);
          ts = int.parse(DateFormat("yyyyMMdd").format(dateTime));
        }
      }
    } catch (e) {
      formattedDate = item.pubDate ?? 'Recent';
    }

    // Prioritize content:encoded for full text, fallback to description
    String fullContent = item.content?.value ?? item.description ?? '';

    return BlogPost(
      id: item.guid ?? item.link ?? '',
      title: item.title ?? 'No Title',
      date: formattedDate.isEmpty ? (item.pubDate ?? 'Recent') : formattedDate,
      excerpt: item.description ?? '',
      content: fullContent,
      category: 'Website',
      timestamp: ts,
      url: item.link,
    );
  }

  factory BlogPost.fromAtom(AtomItem item) {
    String formattedDate = '';
    int ts = 0;
    try {
      if (item.updated != null) {
        DateTime dateTime = DateTime.parse(item.updated!);
        formattedDate = DateFormat("MMM dd, yyyy").format(dateTime);
        ts = int.parse(DateFormat("yyyyMMdd").format(dateTime));
      }
    } catch (e) {
      formattedDate = item.updated ?? 'Recent';
    }

    return BlogPost(
      id: item.id ?? item.links.first.href ?? '',
      title: item.title ?? 'No Title',
      date: formattedDate.isEmpty ? (item.updated ?? 'Recent') : formattedDate,
      excerpt: item.summary ?? '',
      content: item.content ?? item.summary ?? '',
      category: 'Website',
      timestamp: ts,
      url: item.links.isNotEmpty ? item.links.first.href : null,
    );
  }
}
