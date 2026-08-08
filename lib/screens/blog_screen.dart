import 'package:flutter/material.dart';
import 'blog_post_detail_screen.dart';

class BlogPost {
  final String title;
  final String date;
  final String excerpt;
  final String content;
  final String category;

  BlogPost({
    required this.title,
    required this.date,
    required this.excerpt,
    required this.content,
    required this.category,
  });
}

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  static final List<BlogPost> posts = [
    BlogPost(
      title: 'The Future of Content Creator Tax Strategy',
      date: 'Aug 5, 2026',
      excerpt: 'How influencers can optimize their financial health in the evolving digital economy...',
      category: 'Finance',
      content: '''
As the digital economy continues to mature, content creators are facing increasingly complex financial landscapes. At RBM Business Holdings Inc., we've seen a shift in how influencers manage their revenue streams.

Key takeaways for 2026:
1. Entity Structuring: Why an LLC might not be enough anymore.
2. Global Revenue: Handling international sponsorships and tax treaties.
3. Investment Diversification: Moving beyond brand deals into tangible assets.

Strategic planning is no longer optional—it is the foundation of long-term creator success.
      ''',
    ),
    BlogPost(
      title: 'Modernizing IT for Corporate Acquisitions',
      date: 'July 28, 2026',
      excerpt: 'A deep dive into the technical challenges of M&A integration and infrastructure standardizing...',
      category: 'IT Consulting',
      content: '''
Mergers and acquisitions often fail not because of financial misalignment, but because of technical friction. Integrating two disparate IT ecosystems requires a surgical approach.

Our integration framework focuses on:
- Azure AD Consolidation: Creating a unified identity for all employees.
- ERP Migration: Transitioning legacy systems to JD Edwards.
- Policy Alignment: Establishing security protocols that work for the combined entity.

A successful integration starts with a clear technical roadmap.
      ''',
    ),
    BlogPost(
      title: 'Risk Management in a Volatile Market',
      date: 'July 20, 2026',
      excerpt: 'Identifying potential business risks and ensuring compliance in changing industries...',
      category: 'Business',
      content: '''
In today's fast-paced market, risk management is about more than just insurance. It's about being proactive.

We work with businesses to:
- Identify operational risks before they become issues.
- Ensure compliance with shifting federal and local regulations.
- Develop business continuity plans that keep the doors open.

Resilience is built through preparation.
      ''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insights & News')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlogPostDetailScreen(post: post),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        post.category,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      post.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.date,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      post.excerpt,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'Read More',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 16, color: Theme.of(context).primaryColor),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
