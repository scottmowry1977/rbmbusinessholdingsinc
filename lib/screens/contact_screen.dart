import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get In Touch',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Have questions or ready to start your project? Contact us today.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            _buildContactTile(
              context,
              'Email',
              'info@rbmbusinessholdingsinc.com',
              Icons.email,
              () => _launchURL('mailto:info@rbmbusinessholdingsinc.com'),
            ),
            _buildContactTile(
              context,
              'Phone',
              '281-245-0187',
              Icons.phone,
              () => _launchURL('tel:2812450187'),
            ),
            _buildContactTile(
              context,
              'Website',
              'www.rbmbusinessholdingsinc.com',
              Icons.language,
              () => _launchURL('https://rbmbusinessholdingsinc.com'),
            ),
            _buildContactTile(
              context,
              'Location',
              '957 NASA Pkwy #1184\nHouston, TX 77058',
              Icons.location_on,
              () => _launchURL('https://www.google.com/maps/search/?api=1&query=957+NASA+Pkwy+%231184+Houston+TX+77058'),
            ),
            const SizedBox(height: 30),
            const Text(
              'Connect With Us',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSocialIcon(
                  context,
                  'LinkedIn',
                  'https://www.linkedin.com/company/rbm-business-holdings-inc/',
                  Icons.business,
                ),
                _buildSocialIcon(
                  context,
                  'X (Twitter)',
                  'https://twitter.com/RBMBHI',
                  Icons.alternate_email,
                ),
                _buildSocialIcon(
                  context,
                  'Instagram',
                  'https://www.instagram.com/rbmbusinessholdings/',
                  Icons.camera_alt,
                ),
                _buildSocialIcon(
                  context,
                  'Threads',
                  'https://www.threads.net/@rbmbusinessholdings',
                  Icons.forum,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(BuildContext context, String label, String url, IconData icon) {
    return Column(
      children: [
        IconButton.filled(
          onPressed: () => _launchURL(url),
          icon: Icon(icon),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: const Color(0xFFC99700),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildContactTile(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    VoidCallback? onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        onTap: onTap,
        trailing: onTap != null ? const Icon(Icons.open_in_new, size: 16) : null,
      ),
    );
  }
}
