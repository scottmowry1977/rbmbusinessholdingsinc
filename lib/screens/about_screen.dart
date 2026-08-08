import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'Scott Mowry',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'CEO & Founder',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _launchURL('https://www.linkedin.com/company/rbm-business-holdings-inc/'),
                  icon: const Icon(Icons.business),
                  color: const Color(0xFF1A237E),
                  tooltip: 'LinkedIn',
                ),
                IconButton(
                  onPressed: () => _launchURL('https://twitter.com/RBMBHI'),
                  icon: const Icon(Icons.alternate_email),
                  color: const Color(0xFF1A237E),
                  tooltip: 'X (Twitter)',
                ),
                IconButton(
                  onPressed: () => _launchURL('https://www.instagram.com/rbmbusinessholdings/'),
                  icon: const Icon(Icons.camera_alt),
                  color: const Color(0xFF1A237E),
                  tooltip: 'Instagram',
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'RBM Business Holdings Inc. is a full-service professional firm based in Houston, Texas. Led by Scott Mowry, we specialize in providing strategic solutions for both traditional businesses and modern content creators.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'Our firm is positioned as a strategic partner for businesses looking to modernize their infrastructure or optimize their financial planning.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
