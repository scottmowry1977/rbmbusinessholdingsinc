import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/app_drawer.dart';

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

  void _calculateTax() {
    if (_formKey.currentState!.validate()) {
      double gross = double.tryParse(_incomeController.text) ?? 0;
      double expenses = double.tryParse(_expensesController.text) ?? 0;
      double taxableBusinessIncome = gross - expenses;
      if (taxableBusinessIncome < 0) taxableBusinessIncome = 0;
      
      // 2024 Standard Deductions
      double standardDeduction = 14600; // Default: Single
      if (_filingStatus == 'Married (Joint)') {
        standardDeduction = 29200;
      } else if (_filingStatus == 'Head of Household') {
        standardDeduction = 21900;
      }

      // Simplified 2024/2025 estimation logic
      double federalTax = 0;
      double seTax = 0;

      if (_isSelfEmployed) {
        // SE Tax is approx 15.3% on 92.35% of net profit
        seTax = taxableBusinessIncome * 0.9235 * 0.153;
        
        // Deduct 1/2 of SE Tax from taxable income (standard 1040 adjustment)
        taxableBusinessIncome -= (seTax * 0.5);
      }

      // Apply Standard Deduction
      double adjustedTaxable = taxableBusinessIncome - standardDeduction;
      if (adjustedTaxable < 0) adjustedTaxable = 0;

      // 2024 Federal Tax Brackets (Simplified for Single, adjusted slightly for Joint/HoH in a real app)
      // Note: In a production app, we would use separate maps for each status. 
      // For this "Strategic Estimator," we use these as the baseline:
      if (adjustedTaxable <= 11600) {
        federalTax = adjustedTaxable * 0.10;
      } else if (adjustedTaxable <= 47150) {
        federalTax = 1160 + (adjustedTaxable - 11600) * 0.12;
      } else if (adjustedTaxable <= 100525) {
        federalTax = 5426 + (adjustedTaxable - 47150) * 0.22;
      } else {
        federalTax = 17168 + (adjustedTaxable - 100525) * 0.24;
      }

      setState(() {
        _appliedDeduction = standardDeduction;
        _estimatedTax = federalTax + seTax;
        _netIncome = (gross - expenses) - _estimatedTax;
        _effectiveRate = (gross - expenses) > 0 ? (_estimatedTax / (gross - expenses)) * 100 : 0;
      });
    }
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
              const Text(
                'Estimate your tax liability based on 2024 standard deductions and discover strategic targets for savings.',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              
              _buildInputCard(
                context,
                title: 'Business Financials',
                children: [
                  _buildTextField(
                    controller: _incomeController,
                    label: 'Expected Annual Gross Income',
                    icon: Icons.attach_money,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _expensesController,
                    label: 'Estimated Business Expenses',
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
                    decoration: const InputDecoration(
                      labelText: 'Filing Status',
                      helperText: 'Used to apply correct Standard Deduction',
                    ),
                    items: ['Single', 'Married (Joint)', 'Head of Household']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) => setState(() => _filingStatus = val!),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Self-Employed / Independent Contractor'),
                    subtitle: const Text('Calculates SE Tax and 50% adjustment'),
                    value: _isSelfEmployed,
                    activeColor: notreDameGold,
                    onChanged: (val) => setState(() => _isSelfEmployed = val),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _calculateTax,
                style: ElevatedButton.styleFrom(
                  backgroundColor: notreDameNavy,
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: const Text('Calculate Estimate'),
              ),

              if (_estimatedTax > 0) ...[
                const SizedBox(height: 40),
                _buildResultsSection(context),
              ],
              
              const SizedBox(height: 40),
              _buildDisclaimer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard(BuildContext context, {required String title, required List<Widget> children}) {
    return Card(
      elevation: 0,
      color: const Color(0xFF0C2340).withOpacity(0.03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
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

  Widget _buildResultsSection(BuildContext context) {
    const Color notreDameNavy = Color(0xFF0C2340);
    const Color notreDameGold = Color(0xFFC99700);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: notreDameNavy,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: notreDameGold.withOpacity(0.2), blurRadius: 20, spreadRadius: 2),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Estimated Total Tax',
            style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14, letterSpacing: 1.2),
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
            'Applied Standard Deduction: \$${_appliedDeduction.toStringAsFixed(0)}',
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
              color: Colors.white.withOpacity(0.05),
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
      'Disclaimer: This tool provides an estimate for informational purposes only and does not constitute official tax advice. Actual tax liability varies based on complex individual circumstances and local regulations.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
    );
  }
}
