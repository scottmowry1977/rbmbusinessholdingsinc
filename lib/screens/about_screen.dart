import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    
    if (user == null) {
      // Not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to access admin tools.')),
      );
      Navigator.pushNamed(context, '/login');
    } else if (user.email == 'scottm@rbmbusinessholdingsinc.com') {
      // Authorized admin
      Navigator.pushNamed(context, '/admin/uploader');
    } else {
      // Logged in but not admin
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Access Denied: Administrative privileges required.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
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
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF0C2340),
                  ),
            ),
            const Text(
              'CEO & Founder',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFC99700),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(
                  'https://www.linkedin.com/company/rbm-business-holdings-inc/',
                  Icons.business,
                  'LinkedIn',
                ),
                const SizedBox(width: 20),
                _buildSocialIcon(
                  'https://twitter.com/RBMBHI',
                  Icons.alternate_email,
                  'X (Twitter)',
                ),
                const SizedBox(width: 20),
                _buildSocialIcon(
                  'https://www.instagram.com/rbmbusinessholdings/',
                  Icons.camera_alt,
                  'Instagram',
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              'RBM Business Holdings Inc. is a full-service professional firm based in Houston, Texas. Led by Scott Mowry, we specialize in providing strategic solutions for both traditional businesses and modern content creators.',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                height: 1.8,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Our firm is positioned as a strategic partner for businesses looking to modernize their infrastructure or optimize their financial planning.',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                height: 1.8,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
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
        icon: Icon(icon),
        color: const Color(0xFF0C2340),
        tooltip: tooltip,
      ),
    );
  }
}
