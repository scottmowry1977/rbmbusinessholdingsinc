import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/blog_post.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream of articles from Firestore
  Stream<List<BlogPost>> streamArticles() {
    return _db
        .collection('articles')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => BlogPost.fromFirestore(doc)).toList());
  }

  // Future to add an article (useful for testing or future admin panel)
  Future<void> addArticle(Map<String, dynamic> data) async {
    await _db.collection('articles').add(data);
  }
}
