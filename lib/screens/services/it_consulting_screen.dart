import 'package:flutter/material.dart';

class ITConsultingScreen extends StatelessWidget {
  const ITConsultingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Managed IT Consulting')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enterprise-Grade Technology Solutions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'RBM provides proactive 24/7 monitoring and infrastructure management to ensure your technical operations are secure and scalable.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildServiceCard(
              context,
              'Cybersecurity & Threat Detection',
              'Security audits, firewall management, and data protection strategies to safeguard your business assets.',
              Icons.security,
            ),
            _buildServiceCard(
              context,
              'Cloud Solutions (M365 & Azure)',
              'Cloud migration, hosting, and identity management via Azure AD and Virtual Machines.',
              Icons.cloud_done,
            ),
            _buildServiceCard(
              context,
              'Infrastructure & Network Design',
              'Network design (Ubiquiti), hardware procurement, and server installation for modern businesses.',
              Icons.settings_input_component,
            ),
            _buildServiceCard(
              context,
              'Disaster Recovery & Backup',
              'Automated data backups and business continuity planning to ensure minimal downtime in any scenario.',
              Icons.backup,
            ),
            _buildServiceCard(
              context,
              'Managed Helpdesk (Tier 1 & 2)',
              'High-touch support using professional tools like FreshService for incident and asset tracking.',
              Icons.support_agent,
            ),
            _buildServiceCard(
              context,
              'Unified Communications',
              'Modernizing legacy phone systems with cloud-based solutions like RingCentral.',
              Icons.quick_contacts_dialer,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, String detail, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 30, color: Theme.of(context).primaryColor),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(detail, style: const TextStyle(height: 1.3)),
          ),
        ),
      ),
    );
  }
}
