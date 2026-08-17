import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class PdfService {
  static const PdfColor notreDameNavy = PdfColor.fromInt(0xFF0C2340);
  static const PdfColor notreDameGold = PdfColor.fromInt(0xFFC99700);

  Future<void> generateTaxReport({
    required String clientName,
    required String filingStatus,
    required double grossIncome,
    required double expenses,
    required double deduction,
    required double estimatedTax,
    required double netIncome,
    required double effectiveRate,
    required String year,
    double childTaxCredit = 0,
  }) async {
    final pdf = pw.Document();
    final NumberFormat currency = NumberFormat.currency(symbol: '\$');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: const pw.BoxDecoration(
                  color: notreDameNavy,
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'RBM BUSINESS HOLDINGS INC.',
                          style: pw.TextStyle(
                            color: notreDameGold,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'Strategic Tax Estimate Summary',
                          style: const pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    pw.Text(
                      year,
                      style: pw.TextStyle(
                        color: notreDameGold,
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 40),

              // Summary Section
              pw.Text('Client Report Summary', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: notreDameNavy)),
              pw.Divider(color: notreDameGold),
              pw.SizedBox(height: 20),
              
              _buildRow('Filing Status', filingStatus),
              _buildRow('Annual Gross Income', currency.format(grossIncome)),
              _buildRow('Business Expenses', currency.format(expenses)),
              _buildRow('Standard Deduction', currency.format(deduction)),
              if (childTaxCredit > 0)
                _buildRow('Child Tax Credit (Est)', currency.format(childTaxCredit)),
              
              pw.SizedBox(height: 30),
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  color: notreDameNavy,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  children: [
                    _buildRow('Estimated Tax Liability', currency.format(estimatedTax), textColor: PdfColors.white, valueColor: notreDameGold, isBold: true),
                    _buildRow('Net Take-Home Pay', currency.format(netIncome), textColor: PdfColors.white, valueColor: PdfColors.white),
                    _buildRow('Effective Tax Rate', '${effectiveRate.toStringAsFixed(1)}%', textColor: PdfColors.white, valueColor: PdfColors.white),
                  ],
                ),
              ),

              pw.SizedBox(height: 40),
              pw.Text('Strategic Insights', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: notreDameNavy)),
              pw.SizedBox(height: 10),
              pw.Bullet(text: 'RBM clients often see 15-25% reduction in these figures through advanced planning.'),
              pw.Bullet(text: 'This estimate accounts for both Federal Income Tax and Self-Employment Tax thresholds.'),
              pw.Bullet(text: 'Ensure all business deductions are properly categorized for maximum efficiency.'),

              pw.Spacer(),
              pw.Divider(color: notreDameNavy),
              pw.Center(
                child: pw.Text(
                  'Confidential Strategic Document - RBM Business Holdings Inc.',
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _buildRow(String label, String value, {PdfColor? textColor, PdfColor? valueColor, bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(color: textColor, fontWeight: isBold ? pw.FontWeight.bold : null)),
          pw.Text(value, style: pw.TextStyle(color: valueColor ?? textColor, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }
}
