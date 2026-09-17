import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_drawer.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    const Color notreDameNavy = Color(0xFF0C2340);

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : notreDameNavy,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: September 17, 2026',
              style: TextStyle(color: isDark ? Colors.white60 : Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Information We Collect',
              'When you use this app, we may collect information you provide directly, such as your name, '
                  'email address, and company name, when you request a consultation, submit a support request, '
                  'or sign in as an authorized team member. Our tax estimator tool performs calculations on your '
                  'device and does not transmit the figures you enter to our servers.',
            ),
            _buildSection(
              context,
              'How We Use Information',
              'We use the information you provide to respond to consultation and support requests, to manage '
                  'authorized team member access, and to operate and improve this app.',
            ),
            _buildSection(
              context,
              'Third-Party Services',
              'This app uses Google Firebase (Authentication and Cloud Firestore) to operate securely. Requests '
                  'submitted through consultation forms are sent via your device\'s email client and are not stored '
                  'on our servers.',
            ),
            _buildSection(
              context,
              'Data Retention & Security',
              'We retain information only as long as necessary to fulfill the purposes described above, and we use '
                  'industry-standard safeguards to protect it.',
            ),
            _buildSection(
              context,
              'Your Rights',
              'You may request access to, correction of, or deletion of your personal information by contacting us '
                  'at info@rbmbusinessholdingsinc.com.',
            ),
            _buildSection(
              context,
              'Contact Us',
              'If you have questions about this Privacy Policy, contact us at info@rbmbusinessholdingsinc.com or '
                  '281-245-0187.',
            ),
            const SizedBox(height: 16),
            Text(
              'This is a placeholder policy pending legal review. Replace this content with your finalized privacy '
              'policy before submitting to the App Store or Google Play.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: isDark ? Colors.white38 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String body) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    const Color notreDameGold = Color(0xFFC99700);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? notreDameGold : const Color(0xFF0C2340),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
