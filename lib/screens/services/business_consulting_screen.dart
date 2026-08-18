import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/app_drawer.dart';

class BusinessConsultingScreen extends StatelessWidget {
  const BusinessConsultingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color notreDameNavy = Color(0xFF0C2340);
    const Color notreDameGold = Color(0xFFC99700);

    return Scaffold(
      appBar: AppBar(title: const Text('Business Strategy')),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderImagery(context, Icons.rocket_launch_outlined, Icons.trending_up),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Strategic Guidance for Growth',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: notreDameNavy,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'We partner with businesses to improve operations, manage risks, and define actionable growth roadmaps.',
                    style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 40),
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
        color: const Color(0xFF0C2340).withValues(alpha: 0.05),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 40,
            top: -20,
            child: Icon(
              bgIcon,
              size: 250,
              color: const Color(0xFF0C2340).withValues(alpha: 0.03),
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

  Widget _buildStrategyItem(BuildContext context, String title, String detail, IconData icon) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0C2340).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFC99700), size: 28),
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
