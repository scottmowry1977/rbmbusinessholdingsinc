import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/blog_post.dart';

class BlogPostDetailScreen extends StatelessWidget {
  final BlogPost post;

  const BlogPostDetailScreen({super.key, required this.post});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
        actions: [
          if (post.url != null)
            IconButton(
              icon: const Icon(Icons.open_in_browser),
              onPressed: () => _launchURL(post.url!),
              tooltip: 'Open in Browser',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFC99700).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                post.category.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFC99700),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              post.title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0C2340),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  post.date,
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ],
            ),
            const Divider(height: 64),
            Text(
              post.content.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''), // Basic HTML strip
              style: const TextStyle(
                fontSize: 17,
                height: 1.8,
                color: Colors.black87,
                letterSpacing: 0.2,
              ),
            ),
            if (post.url != null) ...[
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => _launchURL(post.url!),
                icon: const Icon(Icons.launch),
                label: const Text('Read full article on website'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
            const SizedBox(height: 60),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/consultation'),
                icon: const Icon(Icons.calendar_month, size: 20),
                label: const Text('Schedule a Consultation'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
