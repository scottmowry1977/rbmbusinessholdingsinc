import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class ConsultationFormScreen extends StatefulWidget {
  const ConsultationFormScreen({super.key});

  @override
  State<ConsultationFormScreen> createState() => _ConsultationFormScreenState();
}

class _ConsultationFormScreenState extends State<ConsultationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedService = 'Financial & Tax Consulting';

  final List<String> _services = [
    'Financial & Tax Consulting',
    'Managed IT Consulting',
    'Business Strategy',
    'M&A Integration',
    'ERP Management',
    'Small Business Support',
  ];

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String body = 'Name: ${_nameController.text}\n'
          'Company: ${_companyController.text}\n'
          'Service Interest: $_selectedService\n\n'
          'Message:\n${_messageController.text}';

      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'info@rbmbusinessholdingsinc.com',
        queryParameters: {
          'subject': 'Consultation Request: $_selectedService',
          'body': body,
        },
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening email client...')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open email client.')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request a Consultation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Let\'s build your strategy.',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0C2340),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Fill out the form below and we will get back to you to schedule a professional consultation.',
                style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person, size: 20),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _companyController,
                decoration: InputDecoration(
                  labelText: 'Company Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.business, size: 20),
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                initialValue: _selectedService,
                decoration: InputDecoration(
                  labelText: 'Service of Interest',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.category, size: 20),
                ),
                items: _services.map((String service) {
                  return DropdownMenuItem(
                    value: service,
                    child: Text(service, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedService = newValue!;
                  });
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'How can we help?',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  alignLabelWithHint: true,
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please tell us a bit about your needs'
                    : null,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: const Text(
                  'Send Request',
                  style: TextStyle(fontSize: 18, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
