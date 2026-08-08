import 'package:flutter/material.dart';

class BusinessConsultingScreen extends StatelessWidget {
  const BusinessConsultingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business Strategy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Strategic Guidance for Growth',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'We partner with businesses to improve operations, manage risks, and define actionable growth roadmaps.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildStrategyItem(
              context,
              'Strategic Planning',
              'Assisting in defining long-term goals and developing comprehensive growth roadmaps.',
              Icons.map,
            ),
            _buildStrategyItem(
              context,
              'Operational Improvement',
              'Analyzing internal workflows to increase efficiency, reduce costs, and streamline processes.',
              Icons.speed,
            ),
            _buildStrategyItem(
              context,
              'Risk Management & Compliance',
              'Identifying potential business risks and ensuring adherence to industry regulations and standards.',
              Icons.gavel,
            ),
            _buildStrategyItem(
              context,
              'Organizational Development',
              'Consulting on corporate structure, leadership management, and HR policy development.',
              Icons.corporate_fare,
            ),
            _buildStrategyItem(
              context,
              'Team Building & Culture',
              'Developing organizational structures that foster collaboration and high performance.',
              Icons.groups,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrategyItem(BuildContext context, String title, String detail, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: Icon(icon, color: Theme.of(context).primaryColor, size: 32),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(detail),
        ),
      ),
    );
  }
}
