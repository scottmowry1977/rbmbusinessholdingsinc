import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/app_drawer.dart';

class ITConsultingScreen extends StatelessWidget {
  const ITConsultingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color notreDameNavy = Color(0xFF0C2340);
    const Color notreDameGold = Color(0xFFC99700);

    return Scaffold(
      appBar: AppBar(title: const Text('Managed IT Consulting')),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderImagery(context, Icons.security_outlined, Icons.dns_outlined),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enterprise-Grade Technology Solutions',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: notreDameNavy,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'RBM provides proactive 24/7 monitoring and infrastructure management to ensure your technical operations are secure and scalable.',
                    style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                  _buildServiceCard(
                    context,
                    'Cybersecurity & Threat Detection',
                    'Security audits, firewall management, and data protection strategies to safeguard your business assets.',
                    Icons.security,
                  ),
                  _buildServiceCard(
                    context,
                    'Cloud Solutions (AWS, M365 & Azure)',
                    'Cloud migration, hosting, and identity management via AWS, Azure AD, and Virtual Machines.',
                    Icons.cloud_done,
                  ),
                  _buildServiceCard(
                    context,
                    'Infrastructure & Network Design',
                    'Network design, hardware procurement, and server installation for modern businesses.',
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
                  _buildServiceCard(
                    context,
                    'Procurement & Vendor Management',
                    'We are partners with multiple top-tier equipment vendors. We manage all hardware and software purchases through our professional vendor system.',
                    Icons.shopping_cart,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImagery(BuildContext context, IconData centerIcon, IconData bgIcon) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFF0C2340).withOpacity(0.05),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -30,
            bottom: -30,
            child: Icon(
              bgIcon,
              size: 250,
              color: const Color(0xFF0C2340).withOpacity(0.03),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Icon(
                centerIcon,
                size: 80,
                color: const Color(0xFFC99700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, String detail, IconData icon) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0C2340).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: const Color(0xFFC99700)),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(detail, style: const TextStyle(height: 1.5, fontSize: 14)),
          ),
        ),
      ),
    );
  }
}
