import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const Color notreDameNavy = Color(0xFF0C2340);
    const Color notreDameGold = Color(0xFFC99700);

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: notreDameNavy,
              border: Border(
                bottom: BorderSide(color: notreDameGold, width: 2),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: notreDameGold, width: 2),
                    ),
                    child: const Text(
                      'RBM',
                      style: TextStyle(
                        color: notreDameGold,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'RBM Holdings',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home_outlined,
                  title: 'Home',
                  route: '/',
                ),
                const Divider(),
                _buildSectionHeader('Professional Services'),
                _buildDrawerItem(
                  context,
                  icon: Icons.account_balance_outlined,
                  title: 'Financial Services',
                  route: '/financial',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.computer_outlined,
                  title: 'IT Consulting',
                  route: '/it',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.trending_up_outlined,
                  title: 'Business Strategy',
                  route: '/business',
                ),
                const Divider(),
                _buildSectionHeader('Interactive Tools'),
                _buildDrawerItem(
                  context,
                  icon: Icons.support_agent_outlined,
                  title: 'Submit IT Ticket',
                  route: '/it-ticket',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.calculate_outlined,
                  title: 'Strategic Tax Estimator',
                  route: '/tax-estimator',
                ),
                const Divider(),
                _buildSectionHeader('Strategic Resources'),
                _buildDrawerItem(
                  context,
                  icon: Icons.article_outlined,
                  title: 'Insights & News',
                  route: '/blog',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.rocket_launch_outlined,
                  title: 'Client Onboarding',
                  route: '/onboarding',
                ),
                const Divider(),
                _buildSectionHeader('Company'),
                _buildDrawerItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'About Us',
                  route: '/about',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.contact_support_outlined,
                  title: 'Contact Us',
                  route: '/contact',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '© 2026 RBM Business Holdings Inc.',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFFC99700), // Notre Dame Gold
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon, required String title, required String route}) {
    final bool isSelected = ModalRoute.of(context)?.settings.name == route;
    const Color notreDameNavy = Color(0xFF0C2340);

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFFC99700) : (isDark ? Colors.white70 : notreDameNavy),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected 
              ? (isDark ? const Color(0xFFC99700) : notreDameNavy) 
              : (isDark ? Colors.white : Colors.black87),
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (!isSelected) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}
