import 'package:cloud_firestore/cloud_firestore.dart';

class BlogPost {
  final String id;
  final String title;
  final String date;
  final String excerpt;
  final String content;
  final String category;
  final int timestamp; // For sorting

  BlogPost({
    required this.id,
    required this.title,
    required this.date,
    required this.excerpt,
    required this.content,
    required this.category,
    required this.timestamp,
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
}
