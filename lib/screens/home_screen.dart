import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RBM Business Holdings Inc.'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildServiceCard(
                        context,
                        'Financial Services',
                        Icons.account_balance,
                        '/financial',
                      ),
                      _buildServiceCard(
                        context,
                        'IT Consulting',
                        Icons.computer,
                        '/it',
                      ),
                      _buildServiceCard(
                        context,
                        'Business Strategy',
                        Icons.trending_up,
                        '/business',
                      ),
                      _buildServiceCard(
                        context,
                        'Insights & News',
                        Icons.article,
                        '/blog',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildLargeNavCard(
                    context,
                    'Client Portal & Onboarding',
                    'Roadmap for new partners and system intake.',
                    Icons.rocket_launch,
                    '/onboarding',
                  ),
                  const SizedBox(height: 20),
                  _buildLargeNavCard(
                    context,
                    'About RBM Holdings',
                    'Learn more about our mission and leadership.',
                    Icons.info_outline,
                    '/about',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/consultation'),
                icon: const Icon(Icons.calendar_today, size: 20),
                label: const Text('Request a Consultation'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/contact'),
              icon: const Icon(Icons.mail_outline),
              label: Text(
                'General Contact',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              icon: const Icon(Icons.login, size: 16),
              label: const Text(
                'Client Login',
                style: TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF071426) : Theme.of(context).primaryColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 3,
          ),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Strategic Solutions for Modern Business',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Expertise in IT Infrastructure, Finance, and M&A Integration',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
      BuildContext context, String title, IconData icon, String route) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 44, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargeNavCard(
      BuildContext context, String title, String subtitle, IconData icon, String route) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        onTap: () => Navigator.pushNamed(context, route),
        leading: Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(subtitle, style: const TextStyle(fontSize: 13)),
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
      ),
    );
  }
}
