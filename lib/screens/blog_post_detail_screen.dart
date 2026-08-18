import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../models/blog_post.dart';

class BlogPostDetailScreen extends StatelessWidget {
  final BlogPost post;

  const BlogPostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    const Color notreDameNavy = Color(0xFF0C2340);
    const Color notreDameGold = Color(0xFFC99700);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: notreDameGold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                post.category.toUpperCase(),
                style: const TextStyle(
                  color: notreDameGold,
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
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : notreDameNavy,
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
            HtmlWidget(
              post.content,
              textStyle: TextStyle(
                fontSize: 16,
                height: 1.7,
                color: isDark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
                letterSpacing: 0.2,
              ),
              customStylesBuilder: (element) {
                if (element.localName == 'h1' || element.localName == 'h2') {
                  return {
                    'color': isDark ? '#C99700' : '#0C2340',
                    'font-family': 'Playfair Display',
                    'font-weight': 'bold',
                    'margin-top': '24px',
                    'margin-bottom': '12px'
                  };
                }
                if (element.localName == 'strong') {
                  return {
                    'color': isDark ? '#FFFFFF' : '#0C2340', 
                    'font-weight': 'bold'
                  };
                }
                return null;
              },
            ),
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
