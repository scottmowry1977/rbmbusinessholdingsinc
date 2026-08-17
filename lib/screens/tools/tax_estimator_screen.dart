import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/app_drawer.dart';
import '../../services/database_service.dart';
import '../../services/pdf_service.dart';

class TaxEstimatorScreen extends StatefulWidget {
  const TaxEstimatorScreen({super.key});

  @override
  State<TaxEstimatorScreen> createState() => _TaxEstimatorScreenState();
}

class _TaxEstimatorScreenState extends State<TaxEstimatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _incomeController = TextEditingController();
  final _expensesController = TextEditingController();
  
  String _filingStatus = 'Single';
  bool _isSelfEmployed = true;
  
  double _estimatedTax = 0;
  double _effectiveRate = 0;
  double _netIncome = 0;
  double _appliedDeduction = 0;
  String _currentYearText = "2026";

  // 2025/2026 Brackets (Baseline Projections)
  final Map<String, List<double>> _thresholds = {
    'Single': [11925, 48475, 103350, 197300, 250525, 626350],
    'Married (Joint)': [23850, 96950, 206700, 394600, 501050, 751600],
    'Head of Household': [17000, 64850, 103350, 197300, 250525, 626350],
  };

  final List<double> _rates = [0.10, 0.12, 0.22, 0.24, 0.32, 0.35, 0.37];

  double _calculateAdvancedFederalTax(double taxableIncome, String status) {
    double tax = 0;
    List<double> currentThresholds = _thresholds[status] ?? _thresholds['Single']!;
    double previousThreshold = 0;

    for (int i = 0; i < currentThresholds.length; i++) {
      if (taxableIncome > currentThresholds[i]) {
        tax += (currentThresholds[i] - previousThreshold) * _rates[i];
        previousThreshold = currentThresholds[i];
      } else {
        tax += (taxableIncome - previousThreshold) * _rates[i];
        return tax;
      }
    }
    
    // Top bracket
    tax += (taxableIncome - previousThreshold) * _rates.last;
    return tax;
  }

  void _calculateTax(Map<String, dynamic> config) {
    if (_formKey.currentState!.validate()) {
      double gross = double.tryParse(_incomeController.text) ?? 0;
      double expenses = double.tryParse(_expensesController.text) ?? 0;
      double taxableBusinessIncome = gross - expenses;
      if (taxableBusinessIncome < 0) taxableBusinessIncome = 0;

      double parseDbValue(dynamic val, double fallback) {
        if (val == null) return fallback;
        if (val is num) return val.toDouble();
        if (val is String) return double.tryParse(val) ?? fallback;
        return fallback;
      }
      
      // Dynamic Standard Deductions from Firebase (with fallbacks)
      double standardDeduction = parseDbValue(config['deduction_single'], 16100);
      if (_filingStatus == 'Married (Joint)') {
        standardDeduction = parseDbValue(config['deduction_joint'], 32200);
      } else if (_filingStatus == 'Head of Household') {
        standardDeduction = parseDbValue(config['deduction_hoh'], 24150);
      }

      double seTax = 0;
      if (_isSelfEmployed) {
        seTax = taxableBusinessIncome * 0.9235 * 0.153;
        taxableBusinessIncome -= (seTax * 0.5); // Adjustment
      }

      double adjustedTaxable = taxableBusinessIncome - standardDeduction;
      if (adjustedTaxable < 0) adjustedTaxable = 0;

      double federalTax = _calculateAdvancedFederalTax(adjustedTaxable, _filingStatus);

      setState(() {
        _appliedDeduction = standardDeduction;
        _estimatedTax = federalTax + seTax;
        _netIncome = (gross - expenses) - _estimatedTax;
        _effectiveRate = (gross - expenses) > 0 ? (_estimatedTax / (gross - expenses)) * 100 : 0;
        _currentYearText = config['config_year'] ?? "2026";
      });
    }
  }

  Future<void> _generatePdf() async {
    await PdfService().generateTaxReport(
      clientName: 'Strategic Client',
      filingStatus: _filingStatus,
      grossIncome: double.tryParse(_incomeController.text) ?? 0,
      expenses: double.tryParse(_expensesController.text) ?? 0,
      deduction: _appliedDeduction,
      estimatedTax: _estimatedTax,
      netIncome: _netIncome,
      effectiveRate: _effectiveRate,
      year: _currentYearText,
    );
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _expensesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color notreDameNavy = Color(0xFF0C2340);
    const Color notreDameGold = Color(0xFFC99700);

    return StreamBuilder<DocumentSnapshot>(
      stream: DatabaseService().streamTaxSettings(),
      builder: (context, snapshot) {
        Map<String, dynamic> config = {};
        if (snapshot.hasData && snapshot.data!.exists) {
          config = snapshot.data!.data() as Map<String, dynamic>;
        }

        final String yearText = config['config_year'] ?? _currentYearText;

        return Scaffold(
          appBar: AppBar(title: const Text('Strategic Tax Estimator')),
          drawer: const AppDrawer(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Plan Your Success',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: notreDameNavy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Precision math based on $yearText IRS thresholds for Federal and SE tax.',
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  
                  _buildInputCard(
                    context,
                    title: 'Business Financials',
                    children: [
                      _buildTextField(
                        controller: _incomeController,
                        label: 'Annual Gross Income',
                        icon: Icons.attach_money,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _expensesController,
                        label: 'Annual Business Expenses',
                        icon: Icons.receipt_long_outlined,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _buildInputCard(
                    context,
                    title: 'Filing Details',
                    children: [
                      DropdownButtonFormField<String>(
                        value: _filingStatus,
                        decoration: const InputDecoration(labelText: 'Filing Status'),
                        items: ['Single', 'Married (Joint)', 'Head of Household']
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (val) => setState(() => _filingStatus = val!),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Self-Employed'),
                        subtitle: const Text('Includes SE Tax and 1040 adjustments'),
                        value: _isSelfEmployed,
                        activeColor: notreDameGold,
                        onChanged: (val) => setState(() => _isSelfEmployed = val),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => _calculateTax(config),
                    child: const Text('Generate Advanced Estimate'),
                  ),

                  if (_estimatedTax > 0) ...[
                    const SizedBox(height: 40),
                    _buildResultsSection(context, yearText),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: _generatePdf,
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('Download PDF Summary'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        side: const BorderSide(color: notreDameNavy),
                        foregroundColor: notreDameNavy,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 40),
                  _buildDisclaimer(),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildInputCard(BuildContext context, {required String title, required List<Widget> children}) {
    return Card(
      elevation: 0,
      color: const Color(0xFF0C2340).withValues(alpha: 0.03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon}) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
    );
  }

  Widget _buildResultsSection(BuildContext context, String year) {
    const Color notreDameNavy = Color(0xFF0C2340);
    const Color notreDameGold = Color(0xFFC99700);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: notreDameNavy,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: notreDameGold.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 2),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Estimated Total Tax Liability ($year)',
            style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 13, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${_estimatedTax.toStringAsFixed(0)}',
            style: GoogleFonts.playfairDisplay(
              color: notreDameGold,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Standard Deduction Applied: \$${_appliedDeduction.toStringAsFixed(0)}',
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const Divider(color: Colors.white24, height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildResultStat('Net Take-Home', '\$${_netIncome.toStringAsFixed(0)}'),
              _buildResultStat('Effective Rate', '${_effectiveRate.toStringAsFixed(1)}%'),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.auto_awesome, color: notreDameGold, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Strategic Target: Our clients often reduce this liability by 15-25% through specialized planning.',
                    style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDisclaimer() {
    return const Text(
      'Disclaimer: This tool is an advanced mathematical estimation and does not constitute official tax advice. Final liability is determined by your official filing and individual circumstances.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
    );
  }
}
