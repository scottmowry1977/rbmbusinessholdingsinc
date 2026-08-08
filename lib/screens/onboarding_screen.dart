import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  final String portalUrl = 'https://rbmbusinessholdingsinc.com/portal'; // Replace with actual portal URL

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _sendLinkToSelf() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: '',
      queryParameters: {
        'subject': 'Link to RBM Client Portal',
        'body': 'Open this link on your computer to complete your onboarding intake:\n\n$portalUrl',
      },
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Client Onboarding')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Roadmap to Success',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Follow these steps to initialize your professional partnership with RBM Business Holdings.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            
            _buildRoadmapStep(
              context,
              1,
              'Contract Execution',
              'Review and sign the professional services agreement sent to your email.',
              Icons.assignment_turned_in,
              true,
            ),
            _buildRoadmapStep(
              context,
              2,
              'Professional Intake',
              'Complete our detailed intake form on a desktop computer for maximum accuracy.',
              Icons.computer,
              false,
            ),
            _buildRoadmapStep(
              context,
              3,
              'System Initialization',
              'Grant secure access to required financial or IT infrastructure systems.',
              Icons.vpn_key,
              false,
            ),

            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),
            
            const Text(
              'Desktop Handoff',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Our intake forms are comprehensive. We recommend completing them on a laptop or desktop.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),
            
            ElevatedButton.icon(
              onPressed: _sendLinkToSelf,
              icon: const Icon(Icons.email_outlined),
              label: const Text('Email Link to My Computer'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _launchURL(portalUrl),
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Open Web Portal Now'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),

            const SizedBox(height: 40),
            _buildPreparationSection(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRoadmapStep(BuildContext context, int number, String title, String detail, IconData icon, bool isDone) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color goldColor = Theme.of(context).colorScheme.secondary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDone ? Colors.green : primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: goldColor, width: 2),
                ),
                child: Center(
                  child: isDone 
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : Text('$number', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              if (number < 3)
                Container(
                  width: 2,
                  height: 40,
                  color: primaryColor.withOpacity(0.3),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(detail, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
          Icon(icon, color: primaryColor.withOpacity(0.5)),
        ],
      ),
    );
  }

  Widget _buildPreparationSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.secondary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 8),
              const Text('Preparation Guide', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Have these items ready before starting intake:', style: TextStyle(fontSize: 14)),
          const SizedBox(height: 12),
          _buildBulletPoint('Federal Tax ID (EIN)'),
          _buildBulletPoint('3 Months of Bank Statements'),
          _buildBulletPoint('Primary Admin Access to IT Systems'),
          _buildBulletPoint('Point of Contact for Daily Operations'),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          const Icon(Icons.arrow_right, size: 18),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
