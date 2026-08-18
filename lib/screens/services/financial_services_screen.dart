import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/app_drawer.dart';

class FinancialServicesScreen extends StatelessWidget {
  const FinancialServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color notreDameNavy = Color(0xFF0C2340);
    const Color notreDameGold = Color(0xFFC99700);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Financial & Tax Services')),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderImagery(context, Icons.analytics_outlined, Icons.account_balance),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comprehensive Financial Management',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : notreDameNavy,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'RBM Business Holdings provides end-to-end financial oversight and strategic tax planning to ensure your business remains profitable and compliant.',
                    style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                  _buildFeatureItem(
                    context,
                    'Tax Strategy & Planning',
                    'Proactive corporate and individual tax planning, preparation, and filing. We build strategies to help you retain more of your income.',
                    Icons.calculate,
                  ),
                  _buildFeatureItem(
                    context,
                    'Bookkeeping & Accounting',
                    'Full-cycle bookkeeping, accounts payable/receivable management, bank reconciliations, and daily financial record-keeping.',
                    Icons.menu_book,
                  ),
                  _buildFeatureItem(
                    context,
                    'Financial Reporting & Analysis',
                    'Preparation of balance sheets, income statements, and cash flow reports. We identify KPIs to monitor your business health.',
                    Icons.bar_chart,
                  ),
                  _buildFeatureItem(
                    context,
                    'Payroll Administration',
                    'Comprehensive payroll processing including tax withholdings, compliance management, and direct deposit services.',
                    Icons.payments,
                  ),
                  _buildFeatureItem(
                    context,
                    'M&A Integration',
                    'Expert guidance for corporate acquisitions, including financial due diligence and structured integration plans.',
                    Icons.handshake,
                  ),
                  _buildFeatureItem(
                    context,
                    'ERP System Management',
                    'Strategic oversight for managing Enterprise Resource Planning systems like JD Edwards, ensuring your back-office tech scales with you.',
                    Icons.settings_suggest,
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFF0C2340).withValues(alpha: 0.05),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -30,
            bottom: -30,
            child: Icon(
              bgIcon,
              size: 250,
              color: const Color(0xFFC99700).withValues(alpha: 0.03),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0C2340) : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
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

  Widget _buildFeatureItem(BuildContext context, String title, String description, IconData icon) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFC99700).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(icon, color: Color(0xFFC99700), size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.2),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 15, 
                    color: isDark ? Colors.white70 : Colors.black54, 
                    height: 1.6
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
