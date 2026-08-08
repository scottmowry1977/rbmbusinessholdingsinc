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
      title: 'Streamlining IT Procurement & Vendor Management',
      date: 'Feb 12, 2026',
      excerpt: 'How RBM\'s direct partnerships with equipment vendors save time and reduce costs for our clients...',
      category: 'IT Consulting',
      content: '''
Managing the lifecycle of hardware and software can be a significant burden for growing businesses. At RBM Business Holdings, we simplify this through our integrated Vendor Management System.

Our approach includes:
- Strategic Partnerships: Direct access to top-tier equipment and software vendors.
- End-to-End Procurement: We handle everything from vendor selection to final purchase and deployment.
- Cost Efficiency: Leveraging our professional network to ensure your business gets the best value and support.

Don't let logistics slow down your technical growth. Our vendor system is designed to keep your infrastructure modern and your operations smooth.
      ''',
    ),
    BlogPost(
      title: 'Tax Strategy for the Modern Content Creator',
      date: 'Feb 2, 2026',
      excerpt: 'How influencers and digital entrepreneurs can retain more income through specialized financial planning...',
      category: 'Finance',
      content: '''
The creator economy is booming, but many digital entrepreneurs are leaving money on the table due to outdated tax strategies. 

At RBM Business Holdings, we specialize in helping content creators navigate:
- Multi-state and international income streams.
- Strategic entity structuring (beyond the basic LLC).
- Maximizing deductions for equipment, travel, and production costs.

Professional financial planning is the difference between a "hobby" and a sustainable media business.
      ''',
    ),
    BlogPost(
      title: 'The Future of Corporate IT & M&A Integration',
      date: 'Jan 15, 2026',
      excerpt: 'Successful mergers and acquisitions require more than just financial alignment—they require technical synergy...',
      category: 'IT Consulting',
      content: '''
Mergers and acquisitions often face significant "technical friction" during the integration phase. 

Our M&A framework focuses on:
- Azure AD Consolidation: Creating a unified identity for the new combined workforce.
- ERP Alignment: Transitioning disparate systems into a unified platform like JD Edwards.
- Data Security: Ensuring no vulnerabilities are introduced during the network merger.

A clear technical roadmap is essential for preserving value during corporate transitions.
      ''',
    ),
    BlogPost(
      title: 'Infrastructure Modernization: The Shift to Cloud',
      date: 'Dec 10, 2025',
      excerpt: 'Why traditional businesses are accelerating their datacenter migrations to Azure and VMWare cloud solutions...',
      category: 'IT Consulting',
      content: '''
Datacenter maintenance is becoming a liability for growth-oriented firms. 

We are seeing an acceleration in:
- Legacy Server Migration: Moving ESXi hosts to scalable cloud environments.
- VDI Implementation: Supporting a remote-first workforce with high-performance virtual desktops.
- Automated Patching: Reducing security risks through environment-wide management systems.

Modernizing your infrastructure isn't just about efficiency—it's about resilience.
      ''',
    ),
    BlogPost(
      title: 'Resilience and Growth: A Founder\'s Journey',
      date: 'Nov 20, 2025',
      excerpt: 'CEO Scott Mowry reflects on the intersection of personal health, professional accountability, and business leadership...',
      category: 'Leadership',
      content: '''
Leadership is as much about personal discipline as it is about professional strategy. 

Drawing from his journey as a returning bodybuilder and heart surgery survivor, Scott Mowry shares insights on:
- Accountability: Bringing the same rigor to the boardroom as the weight room.
- Resilience: Navigating professional setbacks with the same mindset as health recovery.
- Vision: Building a company that stands the test of time by focusing on core values.

At RBM, we believe that a strong business is built on a foundation of strong principles.
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
