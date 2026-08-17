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
  final _salaryController = TextEditingController(text: '50000');
  final _childrenController = TextEditingController(text: '0');
  
  String _entityType = 'Sole Proprietor / 1099';
  String _filingStatus = 'Single';
  bool _isSelfEmployed = true;
  
  double _estimatedTax = 0;
  double _effectiveRate = 0;
  double _netIncome = 0;
  double _appliedDeduction = 0;
  double _seTaxSavings = 0;
  double _appliedCtc = 0;
  String _currentYearText = "2026";

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
    tax += (taxableIncome - previousThreshold) * _rates.last;
    return tax;
  }

  void _calculateTax(Map<String, dynamic> config) {
    if (_formKey.currentState!.validate()) {
      double gross = double.tryParse(_incomeController.text) ?? 0;
      double expenses = double.tryParse(_expensesController.text) ?? 0;
      double businessProfit = gross - expenses;
      if (businessProfit < 0) businessProfit = 0;

      double parseDbValue(dynamic val, double fallback) {
        if (val == null) return fallback;
        if (val is num) return val.toDouble();
        if (val is String) return double.tryParse(val) ?? fallback;
        return fallback;
      }
      
      double standardDeduction = parseDbValue(config['deduction_single'], 16100);
      if (_filingStatus == 'Married (Joint)') {
        standardDeduction = parseDbValue(config['deduction_joint'], 32200);
      } else if (_filingStatus == 'Head of Household') {
        standardDeduction = parseDbValue(config['deduction_hoh'], 24150);
      }

      double totalTaxLiability = 0;
      double fedTax = 0;
      double payrollTax = 0;
      _seTaxSavings = 0;
      _appliedCtc = 0;

      if (_entityType == 'C-Corp') {
        totalTaxLiability = businessProfit * 0.21;
      } 
      else if (_entityType == 'S-Corp') {
        double salary = double.tryParse(_salaryController.text) ?? (businessProfit * 0.4);
        if (salary > businessProfit) salary = businessProfit;
        payrollTax = salary * 0.153;
        double taxableIndividualIncome = businessProfit - standardDeduction;
        if (taxableIndividualIncome < 0) taxableIndividualIncome = 0;
        fedTax = _calculateAdvancedFederalTax(taxableIndividualIncome, _filingStatus);
        
        // S-Corp savings comparison
        double solePropSeTax = businessProfit * 0.9235 * 0.153;
        double solePropFedTax = _calculateAdvancedFederalTax((businessProfit - (solePropSeTax * 0.5)) - standardDeduction, _filingStatus);
        _seTaxSavings = (solePropSeTax + solePropFedTax) - (payrollTax + fedTax);
      } 
      else {
        payrollTax = businessProfit * 0.9235 * 0.153; // SE Tax
        double adjustedTaxable = (businessProfit - (payrollTax * 0.5)) - standardDeduction;
        if (adjustedTaxable < 0) adjustedTaxable = 0;
        fedTax = _calculateAdvancedFederalTax(adjustedTaxable, _filingStatus);
      }

      // Child Tax Credit Logic (Applies to individual fed tax only)
      if (_entityType != 'C-Corp') {
        int numChildren = int.tryParse(_childrenController.text) ?? 0;
        if (numChildren > 0) {
          double maxCtc = numChildren * 2000.0;
          double phaseOutThreshold = (_filingStatus == 'Married (Joint)') ? 400000 : 200000;
          double agi = businessProfit; 
          
          double ctc = maxCtc;
          if (agi > phaseOutThreshold) {
            double excess = agi - phaseOutThreshold;
            ctc = maxCtc - ((excess / 1000).ceil() * 50.0);
            if (ctc < 0) ctc = 0;
          }
          
          if (ctc > fedTax) {
            _appliedCtc = fedTax;
            fedTax = 0;
          } else {
            _appliedCtc = ctc;
            fedTax -= ctc;
          }
        }
      }

      if (_entityType != 'C-Corp') {
        totalTaxLiability = fedTax + payrollTax;
      }

      setState(() {
        _appliedDeduction = standardDeduction;
        _estimatedTax = totalTaxLiability;
        _netIncome = businessProfit - _estimatedTax;
        _effectiveRate = businessProfit > 0 ? (_estimatedTax / businessProfit) * 100 : 0;
        _currentYearText = config['config_year'] ?? "2026";
      });
    }
  }

  Future<void> _generatePdf() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Generating professional report...')));
      await PdfService().generateTaxReport(
        clientName: 'Strategic Business Client',
        filingStatus: '$_entityType - $_filingStatus',
        grossIncome: double.tryParse(_incomeController.text) ?? 0,
        expenses: double.tryParse(_expensesController.text) ?? 0,
        deduction: _appliedDeduction,
        estimatedTax: _estimatedTax,
        netIncome: _netIncome,
        effectiveRate: _effectiveRate,
        year: _currentYearText,
        childTaxCredit: _appliedCtc,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    }
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
                  Text('Business Strategy Tool', style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: notreDameNavy)),
                  const SizedBox(height: 32),
                  
                  _buildInputCard(
                    context,
                    title: 'Entity Configuration',
                    children: [
                      DropdownButtonFormField<String>(
                        value: _entityType,
                        decoration: const InputDecoration(labelText: 'Business Entity Type'),
                        items: ['Sole Proprietor / 1099', 'S-Corp', 'C-Corp']
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (val) => setState(() {
                          _entityType = val!;
                          _isSelfEmployed = (_entityType == 'Sole Proprietor / 1099');
                        }),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _buildInputCard(
                    context,
                    title: 'Revenue & Expenses',
                    children: [
                      _buildTextField(controller: _incomeController, label: 'Annual Gross Income', icon: Icons.attach_money),
                      const SizedBox(height: 16),
                      _buildTextField(controller: _expensesController, label: 'Annual Business Expenses', icon: Icons.receipt_long),
                      if (_entityType == 'S-Corp') ...[
                        const SizedBox(height: 16),
                        _buildTextField(controller: _salaryController, label: 'Owner W-2 Salary', icon: Icons.person_outline),
                        const Text('Strategic Note: S-Corp savings rely on setting a "Reasonable Salary."', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _buildInputCard(
                    context,
                    title: 'Filing & Family Status',
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
                      _buildTextField(
                        controller: _childrenController, 
                        label: 'Number of Qualifying Children', 
                        icon: Icons.child_care,
                      ),
                      const Text('IRS Child Tax Credit: $2,000 per qualifying child (Subject to phase-out).', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
                    ],
                  ),

                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => _calculateTax(config),
                    child: const Text('Calculate Strategic Liability'),
                  ),

                  if (_estimatedTax > 0) ...[
                    const SizedBox(height: 40),
                    _buildResultsSection(context, config['config_year'] ?? "2026"),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          ...children,
        ]),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon}) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
    );
  }

  Widget _buildResultsSection(BuildContext context, String year) {
    const Color notreDameGold = Color(0xFFC99700);
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: const Color(0xFF0C2340), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: notreDameGold.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 2)]),
      child: Column(children: [
        Text('Estimated Total Liability ($year)', style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 13, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        Text('\$${_estimatedTax.toStringAsFixed(0)}', style: GoogleFonts.playfairDisplay(color: notreDameGold, fontSize: 48, fontWeight: FontWeight.bold)),
        if (_appliedCtc > 0) ...[
          const SizedBox(height: 4),
          Text('Includes \$${_appliedCtc.toStringAsFixed(0)} Child Tax Credit', style: const TextStyle(color: Colors.white60, fontSize: 12)),
        ],
        const Divider(color: Colors.white24, height: 40),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _buildResultStat('Net Profit', '\$${_netIncome.toStringAsFixed(0)}'),
          _buildResultStat('Effective Rate', '${_effectiveRate.toStringAsFixed(1)}%'),
        ]),
        if (_seTaxSavings > 0) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Text('Potential SE Tax Savings: \$${_seTaxSavings.toStringAsFixed(0)}', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      ]),
    );
  }

  Widget _buildResultStat(String label, String value) {
    return Column(children: [
      Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    ]);
  }

  Widget _buildDisclaimer() {
    return const Text('Disclaimer: This is a high-level strategic estimation and not official tax advice.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic));
  }
}
