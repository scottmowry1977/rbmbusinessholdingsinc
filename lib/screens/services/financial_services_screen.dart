import 'package:flutter/material.dart';

class FinancialServicesScreen extends StatelessWidget {
  const FinancialServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Financial & Tax Services')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comprehensive Financial Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'RBM Business Holdings provides end-to-end financial oversight and strategic tax planning to ensure your business remains profitable and compliant.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
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
    );
  }

  Widget _buildFeatureItem(BuildContext context, String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
