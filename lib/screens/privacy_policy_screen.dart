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
              'Overview',
              'RBM Business Holdings Inc. ("RBM," "we," "us," or "our") respects your privacy. This Privacy Policy '
                  'explains what information the RBM Holdings app collects, how we use it, and the choices you have. '
                  'By using this app, you agree to the practices described below.',
            ),
            _buildSection(
              context,
              'Information You Provide to Us',
              'Consultation Requests: When you submit the "Request a Consultation" form, the app opens your '
                  'device\'s email app with your name, company name, service interest, and message pre-filled. That '
                  'message is sent directly from your email account to info@rbmbusinessholdingsinc.com — it '
                  'passes through your own email provider, not through our servers, and we only receive it if you '
                  'choose to send it.\n\n'
                  'Authorized Team Member Sign-In: The app includes a login for RBM personnel to manage published '
                  'content. If you sign in, we process your email address and password through Google Firebase '
                  'Authentication to verify your identity. This sign-in is not available for public account '
                  'creation.\n\n'
                  'Contacting Us: If you email, call, or message us through the links in the app (including social '
                  'media), we receive whatever information you choose to share in that conversation, subject to '
                  'that platform\'s own privacy practices.',
            ),
            _buildSection(
              context,
              'Information We Do Not Collect',
              'The Strategic Tax Estimator performs all calculations locally on your device. The figures you enter '
                  '(income, expenses, dependents, etc.) are never transmitted to us or stored on our servers. This '
                  'app does not access your camera, photos, contacts, precise location, or microphone, and it does '
                  'not contain advertising or third-party tracking or analytics SDKs.',
            ),
            _buildSection(
              context,
              'How We Use Information',
              'We use the information described above to respond to consultation requests, verify authorized team '
                  'member access, publish and display company insights and articles, and operate, secure, and '
                  'improve the app. We do not sell your personal information.',
            ),
            _buildSection(
              context,
              'Third-Party Services',
              'This app relies on the following service providers, each of which processes data under its own '
                  'privacy policy:\n\n'
                  '• Google Firebase (Authentication & Cloud Firestore) — secures sign-in and stores '
                  'published articles and app configuration.\n'
                  '• Google Fonts — may load font files from Google\'s servers to display text styles in '
                  'the app.\n\n'
                  'Links to our website, email, phone, and social media (LinkedIn, X, Instagram, Threads) open '
                  'outside this app and are governed by those services\' own privacy policies.',
            ),
            _buildSection(
              context,
              'Data Retention & Security',
              'We retain the information described above only as long as necessary for the purposes stated in this '
                  'policy, or as required by law. We use industry-standard administrative and technical safeguards, '
                  'including Firebase\'s security infrastructure, to protect the information we hold.',
            ),
            _buildSection(
              context,
              'Children\'s Privacy',
              'This app is intended for business use and is not directed at children under 13. We do not knowingly '
                  'collect personal information from children.',
            ),
            _buildSection(
              context,
              'Your Choices',
              'You may request access to, correction of, or deletion of personal information we hold about you by '
                  'contacting us at info@rbmbusinessholdingsinc.com. Authorized team members may request removal of '
                  'their sign-in credentials at any time through the same contact.',
            ),
            _buildSection(
              context,
              'Changes to This Policy',
              'We may update this Privacy Policy from time to time. Changes will be reflected by an updated "Last '
                  'updated" date at the top of this page and, where required, we will provide additional notice.',
            ),
            _buildSection(
              context,
              'Contact Us',
              'If you have questions about this Privacy Policy or how we handle your information, contact us at:\n\n'
                  'RBM Business Holdings Inc.\n'
                  '957 NASA Pkwy #1184, Houston, TX 77058\n'
                  'info@rbmbusinessholdingsinc.com\n'
                  '281-245-0187',
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
