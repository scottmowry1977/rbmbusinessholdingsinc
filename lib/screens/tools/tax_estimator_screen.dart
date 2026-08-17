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
  final _adjustmentsController = TextEditingController(text: '0');
  
  String _entityType = 'Sole Proprietor / 1099';
  String _filingStatus = 'Single';
  
  double _estimatedTotalTax = 0;
  double _fedTaxPart = 0;
  double _ficaTaxPart = 0;
  double _effectiveRate = 0;
  double _netIncome = 0;
  double _appliedDeduction = 0;
  double _seTaxSavings = 0;
  double _appliedCtc = 0;
  String _currentYearText = "2026";

  // 2026 Federal Brackets (Baseline)
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
      double adjustments = double.tryParse(_adjustmentsController.text) ?? 0;
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

      double fedTax = 0;
      double ficaTax = 0;
      _seTaxSavings = 0;
      _appliedCtc = 0;

      // 2026 FICA/SE Math
      const double ssWageBase = 184500;
      const double ssRate = 0.124; // 12.4% total
      const double medicareRate = 0.029; // 2.9% total

      if (_entityType == 'C-Corp') {
        fedTax = businessProfit * 0.21;
      } 
      else if (_entityType == 'S-Corp') {
        double salary = double.tryParse(_salaryController.text) ?? (businessProfit * 0.4);
        if (salary > businessProfit) salary = businessProfit;
        
        // 1. FICA on Salary (Employer + Employee)
        double ssPart = (salary > ssWageBase ? ssWageBase : salary) * ssRate;
        double medPart = salary * medicareRate;
        ficaTax = ssPart + medPart;
        
        // 2. Individual pass-through tax
        double taxableIndividualIncome = businessProfit - standardDeduction - adjustments;
        if (taxableIndividualIncome < 0) taxableIndividualIncome = 0;
        fedTax = _calculateAdvancedFederalTax(taxableIndividualIncome, _filingStatus);
        
        // Savings comparison
        double spProfitForSe = businessProfit * 0.9235;
        double spSs = (spProfitForSe > ssWageBase ? ssWageBase : spProfitForSe) * ssRate;
        double spMed = spProfitForSe * medicareRate;
        double spSeTotal = spSs + spMed;
        double spFed = _calculateAdvancedFederalTax((businessProfit - (spSeTotal * 0.5)) - standardDeduction - adjustments, _filingStatus);
        _seTaxSavings = (spSeTotal + spFed) - (ficaTax + fedTax);
      } 
      else {
        // Sole Prop / 1099
        double profitForSe = businessProfit * 0.9235;
        double ssPart = (profitForSe > ssWageBase ? ssWageBase : profitForSe) * ssRate;
        double medPart = profitForSe * medicareRate;
        ficaTax = ssPart + medPart;

        double adjustedTaxable = (businessProfit - (ficaTax * 0.5)) - standardDeduction - adjustments;
        if (adjustedTaxable < 0) adjustedTaxable = 0;
        fedTax = _calculateAdvancedFederalTax(adjustedTaxable, _filingStatus);
      }

      // Child Tax Credit (Individual only)
      if (_entityType != 'C-Corp') {
        int numChildren = int.tryParse(_childrenController.text) ?? 0;
        if (numChildren > 0) {
          double maxCtc = numChildren * 2000.0;
          double phaseOutThreshold = (_filingStatus == 'Married (Joint)') ? 400000 : 200000;
          double ctc = maxCtc;
          if (businessProfit > phaseOutThreshold) {
            ctc = maxCtc - ((businessProfit - phaseOutThreshold) / 1000).ceil() * 50.0;
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

      setState(() {
        _appliedDeduction = standardDeduction;
        _fedTaxPart = fedTax;
        _ficaTaxPart = ficaTax;
        _estimatedTotalTax = fedTax + ficaTax;
        _netIncome = businessProfit - _estimatedTotalTax;
        _effectiveRate = businessProfit > 0 ? (_estimatedTotalTax / businessProfit) * 100 : 0;
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
        estimatedTax: _estimatedTotalTax,
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
  void dispose() {
    _incomeController.dispose();
    _expensesController.dispose();
    _salaryController.dispose();
    _childrenController.dispose();
    _adjustmentsController.dispose();
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
                        }),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _buildInputCard(
                    context,
                    title: 'Financials & Adjustments',
                    children: [
                      _buildTextField(controller: _incomeController, label: 'Annual Gross Income', icon: Icons.attach_money),
                      const SizedBox(height: 16),
                      _buildTextField(controller: _expensesController, label: 'Annual Business Expenses', icon: Icons.receipt_long),
                      const SizedBox(height: 16),
                      _buildTextField(controller: _adjustmentsController, label: 'Strategic Adjustments (401k/SEP/Health)', icon: Icons.savings_outlined),
                      if (_entityType == 'S-Corp') ...[
                        const SizedBox(height: 16),
                        _buildTextField(controller: _salaryController, label: 'Owner W-2 Salary', icon: Icons.person_outline),
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
                    ],
                  ),

                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => _calculateTax(config),
                    child: const Text('Calculate Strategic Liability'),
                  ),

                  if (_estimatedTotalTax > 0) ...[
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
        Text('\$${_estimatedTotalTax.toStringAsFixed(0)}', style: GoogleFonts.playfairDisplay(color: notreDameGold, fontSize: 48, fontWeight: FontWeight.bold)),
        
        const Divider(color: Colors.white24, height: 40),
        
        _buildStatRow('Fed Income Tax (Net)', '\$${_fedTaxPart.toStringAsFixed(0)}'),
        _buildStatRow('FICA / SE Tax', '\$${_ficaTaxPart.toStringAsFixed(0)}'),
        if (_appliedCtc > 0) _buildStatRow('Child Tax Credit', '-\$${_appliedCtc.toStringAsFixed(0)}', color: Colors.greenAccent),
        
        const Divider(color: Colors.white24, height: 40),
        
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _buildResultStat('Net Take-Home', '\$${_netIncome.toStringAsFixed(0)}'),
          _buildResultStat('Effective Rate', '${_effectiveRate.toStringAsFixed(1)}%'),
        ]),
        
        if (_seTaxSavings > 0) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Text('S-Corp SE Tax Savings: \$${_seTaxSavings.toStringAsFixed(0)}', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      ]),
    );
  }

  Widget _buildStatRow(String label, String value, {Color color = Colors.white70}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 14)),
          Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
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
    return const Text('Disclaimer: This is a high-level strategic estimation based on projected 2026 FICA and IRS thresholds. Not official tax advice.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic));
  }
}
