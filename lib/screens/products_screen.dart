import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_drawer.dart';

class SaasProduct {
  final String title;
  final String tagline;
  final String description;
  final List<String> features;
  final String webUrl;
  final String buttonText;
  final String badge;
  final Color badgeColor;
  final IconData icon;

  const SaasProduct({
    required this.title,
    required this.tagline,
    required this.description,
    required this.features,
    required this.webUrl,
    required this.buttonText,
    required this.badge,
    required this.badgeColor,
    required this.icon,
  });
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  static const List<SaasProduct> products = [
    SaasProduct(
      title: 'Sextant CRM',
      tagline: 'The CRM built for firms that mean business.',
      description:
          'Sextant CRM is a purpose-built customer relationship management platform designed for professional service firms and B2B businesses. Track leads, manage client pipelines, automate follow-ups, and get clear visibility into every stage of your sales cycle — without the bloat of enterprise software. Sextant CRM is live and ready for firms starting today.',
      features: [
        'Visual pipeline and deal management',
        'Contact and account tracking',
        'Automated follow-up workflows',
        'Reporting and performance dashboards',
        'Team collaboration tools',
        'Built for professional service firms',
      ],
      webUrl: 'https://rbmbusinessholdingsinc.com/products',
      buttonText: 'Visit Sextant CRM',
      badge: 'Live',
      badgeColor: Color(0xFF2E7D32), // Green
      icon: Icons.hub,
    ),
    SaasProduct(
      title: 'MarginTruck',
      tagline: "A food truck's best friend.",
      description:
          'MarginTruck is the all-in-one SaaS platform built specifically for food truck operators. From point-of-sale and inventory tracking to route planning and profit analytics, MarginTruck gives food truck owners the tools they need to run a tighter, more profitable operation — right from their phone.',
      features: [
        'Point-of-sale built for mobile operations',
        'Real-time inventory and supply tracking',
        'Profit margin analytics by menu item',
        'Route and event scheduling',
        'Sales reporting and trend analysis',
        'Built specifically for food truck operators',
      ],
      webUrl: 'https://rbmbusinessholdingsinc.com/products',
      buttonText: 'Visit MarginTruck',
      badge: 'Live',
      badgeColor: Color(0xFF2E7D32), // Green
      icon: Icons.local_shipping,
    ),
    SaasProduct(
      title: 'Vantrix Logistics',
      tagline: 'Smarter freight. Simpler operations.',
      description:
          'Vantrix Logistics is a logistics management platform built for trucking companies, freight brokers, and 3PLs. It streamlines dispatch, load management, carrier coordination, and real-time shipment tracking — giving logistics teams a single command center to manage their entire operation more efficiently.',
      features: [
        'Dispatch and load management',
        'Carrier and driver coordination',
        'Real-time shipment tracking',
        'Route optimization tools',
        'Document and compliance management',
        'Reporting and operational analytics',
      ],
      webUrl: 'https://rbmbusinessholdingsinc.com/products',
      buttonText: 'Visit Vantrix Logistics',
      badge: 'Live',
      badgeColor: Color(0xFF2E7D32), // Green
      icon: Icons.alt_route,
    ),
  ];

  Future<void> _launchURL(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $urlString')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color notreDameNavy = Color(0xFF0C2340);
    const Color notreDameGold = Color(0xFFC99700);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products & SaaS Platforms'),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Center(
              child: Column(
                children: [
                  Text(
                    'OUR DIGITAL ECOSYSTEM',
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: notreDameGold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'SaaS Platforms & Software',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : notreDameNavy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 50,
                    height: 3,
                    color: notreDameGold,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Purpose-built software platforms developed by RBM Business Holdings to empower modern firms, food truck operators, and logistics teams.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark ? Colors.white70 : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Product Cards List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              separatorBuilder: (context, index) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(context, product, isDark);
              },
            ),

            const SizedBox(height: 32),

            // Work With Us CTA Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF071426) : notreDameNavy,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: notreDameGold, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    'Work With Us',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Looking for custom software development or IT consulting for your business?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/consultation'),
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: const Text('Schedule a Consultation'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: notreDameGold,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
      BuildContext context, SaasProduct product, bool isDark) {
    const Color notreDameNavy = Color(0xFF0C2340);
    const Color notreDameGold = Color(0xFFC99700);

    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: notreDameGold.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Row with Icon, Title, and Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: notreDameNavy.withValues(alpha: isDark ? 0.4 : 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    product.icon,
                    size: 28,
                    color: notreDameGold,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              product.title,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : notreDameNavy,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: product.badgeColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: product.badgeColor.withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: product.badgeColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  product.badge,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: product.badgeColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.tagline,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: notreDameGold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              product.description,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Feature List
            Text(
              'Key Features:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: isDark ? Colors.white60 : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            ...product.features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: notreDameGold,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.8)
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action Button
            ElevatedButton.icon(
              onPressed: () => _launchURL(context, product.webUrl),
              icon: const Icon(Icons.launch, size: 18),
              label: Text(product.buttonText),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: notreDameNavy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
