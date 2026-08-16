import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/app_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _handleAdminAccess(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    debugPrint('Current User Email: ${user?.email}');
    
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to access admin tools.')),
      );
      Navigator.pushNamed(context, '/login');
    } else if (user.email?.toLowerCase().trim() == 'scottm@rbmbusinessholdingsinc.com' ||
               user.email?.toLowerCase().trim() == 'scott@rbmbusinessholdingsinc.com') {
      Navigator.pushNamed(context, '/admin/uploader');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Access Denied: Logged in as ${user.email}. Admin required.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color notreDameNavy = Color(0xFF0C2340);
    const Color notreDameGold = Color(0xFFC99700);

    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          children: [
            // Section 1: Our Story
            _buildSectionHeader(context, 'Our Story', 'Built to Serve Small Businesses'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Text(
                'RBM Business Holdings Inc. was founded on a simple belief: small businesses deserve the same quality of professional services that large corporations enjoy — without the enterprise price tag.\n\n'
                'We recognized that most small business owners were juggling multiple vendors for accounting, taxes, consulting, and IT — wasting time, money, and energy coordinating between them. We built RBM to change that.\n\n'
                'Today, we serve hundreds of clients across industries, providing integrated, expert services that simplify operations and fuel growth — all under one roof.',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  height: 1.8,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 40),

            // Section 2: Mission, Vision & Values
            _buildSectionHeader(context, 'Mission, Vision & Values', 'The RBM Commitment'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                children: [
                  _buildValueCard(
                    context,
                    'Our Mission',
                    'To empower small businesses and individuals with professional-grade accounting, tax, consulting, and IT services that drive growth and financial confidence.',
                    Icons.flag_outlined,
                  ),
                  const SizedBox(height: 24),
                  _buildValueCard(
                    context,
                    'Our Vision',
                    'To be the most trusted all-in-one business services partner for small businesses and entrepreneurs across our community and beyond.',
                    Icons.visibility_outlined,
                  ),
                  const SizedBox(height: 24),
                  _buildValueCard(
                    context,
                    'Our Values',
                    'Integrity, transparency, and client-first thinking guide everything we do. We treat every client\'s business as if it were our own.',
                    Icons.favorite_border,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 40),

            // Section 3: Meet Our Leadership Team
            _buildSectionHeader(context, 'Meet Our Leadership Team', 'Strategic Guidance & Innovation'),
            const SizedBox(height: 48),
            _buildLeaderProfile(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String subtitle) {
    const Color notreDameNavy = Color(0xFF0C2340);
    const Color notreDameGold = Color(0xFFC99700);

    return Column(
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: notreDameGold,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : notreDameNavy,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 3,
          color: notreDameGold,
        ),
      ],
    );
  }

  Widget _buildValueCard(BuildContext context, String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0C2340).withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC99700).withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFC99700), size: 32),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderProfile(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onLongPress: () => _handleAdminAccess(context),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFC99700), width: 2),
            ),
            child: CircleAvatar(
              radius: 70,
              backgroundColor: Colors.grey[200],
              backgroundImage: const AssetImage('assets/images/scott_mowry_profile.jpg'),
              child: null,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Scott Mowry',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 24,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF0C2340),
              ),
        ),
        const Text(
          'CEO & Founder',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFC99700),
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIcon(
              'https://www.linkedin.com/company/rbm-business-holdings-inc/',
              Icons.business,
              'LinkedIn',
            ),
            const SizedBox(width: 16),
            _buildSocialIcon(
              'https://twitter.com/RBMBHI',
              Icons.alternate_email,
              'X (Twitter)',
            ),
            const SizedBox(width: 16),
            _buildSocialIcon(
              'https://www.instagram.com/rbmbusinessholdings/',
              Icons.camera_alt,
              'Instagram',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(String url, IconData icon, String tooltip) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0C2340).withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () => _launchURL(url),
        icon: Icon(icon, size: 20),
        color: const Color(0xFF0C2340),
        tooltip: tooltip,
      ),
    );
  }
}
