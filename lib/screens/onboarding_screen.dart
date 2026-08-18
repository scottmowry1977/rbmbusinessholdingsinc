import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_drawer.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: const Text('Client Onboarding'),
            pinned: true,
            floating: true,
            forceElevated: innerBoxIsScrolled,
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
              indicatorColor: const Color(0xFFC99700),
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(text: 'GENERAL & IT', icon: Icon(Icons.business_center, size: 20)),
                Tab(text: 'TAX CLIENTS', icon: Icon(Icons.calculate, size: 20)),
                Tab(text: 'ACCOUNTING', icon: Icon(Icons.account_balance, size: 20)),
                Tab(text: 'CONSULTING', icon: Icon(Icons.trending_up, size: 20)),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildGeneralOnboarding(context),
            _buildTaxOnboarding(context),
            _buildAccountingOnboarding(context),
            _buildBusinessOnboarding(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralOnboarding(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Your Roadmap to Success'),
          const SizedBox(height: 12),
          const Text(
            'Follow these steps to initialize your professional partnership with RBM Business Holdings.',
            style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 40),
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
            'Complete our detailed intake form on your desktop computer.',
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
          _buildDesktopHandoff(context),
          const SizedBox(height: 40),
          _buildPreparationSection(
            context,
            'General Preparation Guide',
            [
              'Federal Tax ID (EIN)',
              '3 Months of Bank Statements',
              'Primary Admin Access to IT Systems',
              'Point of Contact for Daily Operations',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaxOnboarding(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Tax Client Roadmap'),
          const SizedBox(height: 12),
          const Text(
            'Streamlined onboarding for individual and corporate tax planning clients.',
            style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 40),
          _buildRoadmapStep(
            context,
            1,
            'Document Collection',
            'Gather prior year returns and current year income/expense records.',
            Icons.folder_shared,
            true,
          ),
          _buildRoadmapStep(
            context,
            2,
            'Tax Intake Session',
            'Complete the specialized tax intake form on your desktop computer.',
            Icons.description,
            false,
          ),
          _buildRoadmapStep(
            context,
            3,
            'Advisory Session',
            'Schedule your initial tax strategy meeting with our consultants.',
            Icons.event_available,
            false,
          ),
          _buildDesktopHandoff(context),
          const SizedBox(height: 40),
          _buildPreparationSection(
            context,
            'Tax Preparation Guide',
            [
              'Prior 2 Years of Tax Returns',
              'All W2, 1099, and K-1 Documents',
              'Business Expense Logs & Receipt Summaries',
              'Investment & Real Estate Records',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountingOnboarding(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Accounting Roadmap'),
          const SizedBox(height: 12),
          const Text(
            'Transitioning your daily financial operations to RBM management.',
            style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 40),
          _buildRoadmapStep(
            context,
            1,
            'Software Integration',
            'Connect your QuickBooks, Xero, or legacy ERP systems to our secure cloud.',
            Icons.sync,
            true,
          ),
          _buildRoadmapStep(
            context,
            2,
            'Historical Review',
            'Our team audits the last 6-12 months of records to ensure a clean starting point.',
            Icons.fact_check,
            false,
          ),
          _buildRoadmapStep(
            context,
            3,
            'Reporting Cycle Setup',
            'Establish your monthly and quarterly reporting deadlines and KPI dashboards.',
            Icons.published_with_changes,
            false,
          ),
          _buildDesktopHandoff(context),
          const SizedBox(height: 40),
          _buildPreparationSection(
            context,
            'Accounting Preparation Guide',
            [
              'Admin access to current accounting software',
              'Current Trial Balance and General Ledger',
              'Full Vendor and Customer lists',
              'Open Accounts Payable/Receivable reports',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessOnboarding(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Consulting Roadmap'),
          const SizedBox(height: 12),
          const Text(
            'Laying the foundation for your business growth and operational efficiency.',
            style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 40),
          _buildRoadmapStep(
            context,
            1,
            'Discovery Phase',
            'In-depth interviews with key stakeholders to identify core pain points.',
            Icons.search,
            true,
          ),
          _buildRoadmapStep(
            context,
            2,
            'Operational Audit',
            'A comprehensive review of your current workflows and organizational structure.',
            Icons.analytics,
            false,
          ),
          _buildRoadmapStep(
            context,
            3,
            'Strategic Kickoff',
            'The formal presentation of your 12-month growth roadmap and key objectives.',
            Icons.rocket,
            false,
          ),
          _buildDesktopHandoff(context),
          const SizedBox(height: 40),
          _buildPreparationSection(
            context,
            'Consulting Preparation Guide',
            [
              'Current Organizational Chart',
              'Documentation of existing core processes',
              'List of top 3 operational challenges',
              'Access to historical performance data',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF0C2340),
      ),
    );
  }

  Widget _buildDesktopHandoff(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),
        const Divider(),
        const SizedBox(height: 32),
        const Text(
          'Next Steps: Desktop Intake',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0C2340).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF0C2340).withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              const Icon(Icons.laptop_mac, size: 48, color: Color(0xFF0C2340)),
              const SizedBox(height: 16),
              Text(
                'To ensure the highest accuracy for your business data, our intake forms must be completed on a computer.',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0C2340),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Please visit rbmbusinessholdingsinc.com on your desktop or laptop and navigate to the Client Forms page to begin.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoadmapStep(BuildContext context, int number, String title, String detail, IconData icon, bool isDone) {
    const Color primaryColor = Color(0xFF0C2340);
    const Color goldColor = Color(0xFFC99700);

    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDone ? Colors.green : primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: goldColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: isDone 
                    ? const Icon(Icons.check, color: Colors.white, size: 24)
                    : Text('$number', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ),
              if (number < 3)
                Container(
                  width: 2,
                  height: 48,
                  color: primaryColor.withValues(alpha: 0.15),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.2)),
                const SizedBox(height: 6),
                Text(detail, style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: primaryColor.withValues(alpha: 0.2), size: 28),
        ],
      ),
    );
  }

  Widget _buildPreparationSection(BuildContext context, String title, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFC99700).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC99700).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: Color(0xFFC99700), size: 24),
              const SizedBox(width: 12),
              Text(
                title, 
                style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0C2340)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Have these items ready before starting intake:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
          ...items.map((item) => _buildBulletPoint(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 16, color: Color(0xFFC99700)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87))),
        ],
      ),
    );
  }
}
