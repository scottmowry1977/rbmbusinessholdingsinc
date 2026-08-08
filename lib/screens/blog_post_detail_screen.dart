import 'package:flutter/material.dart';
import 'blog_screen.dart';

class BlogPostDetailScreen extends StatelessWidget {
  final BlogPost post;

  const BlogPostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Article')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.category,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              post.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              post.date,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const Divider(height: 40),
            Text(
              post.content,
              style: const TextStyle(fontSize: 18, height: 1.6),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/consultation'),
                icon: const Icon(Icons.calendar_month),
                label: const Text('Schedule a Consultation'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
