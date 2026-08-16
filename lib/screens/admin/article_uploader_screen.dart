import 'package:flutter/material.dart';
import '../../services/database_service.dart';

class ArticleUploaderScreen extends StatefulWidget {
  const ArticleUploaderScreen({super.key});

  @override
  State<ArticleUploaderScreen> createState() => _ArticleUploaderScreenState();
}

class _ArticleUploaderScreenState extends State<ArticleUploaderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _excerptController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isPublishing = false;

  Future<void> _publishArticle() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isPublishing = true);
      
      try {
        final now = DateTime.now();
        final String dateStr = "${_getMonth(now.month)} ${now.day}, ${now.year}";
        final int timestamp = int.parse("${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}");

        await DatabaseService().addArticle({
          'title': _titleController.text.trim(),
          'category': _categoryController.text.trim(),
          'excerpt': _excerptController.text.trim(),
          'content': _contentController.text.trim(),
          'date': dateStr,
          'timestamp': timestamp,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Article Published Successfully!')),
          );
          _titleController.clear();
          _categoryController.clear();
          _excerptController.clear();
          _contentController.clear();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isPublishing = false);
      }
    }
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _excerptController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Article Uploader (Admin)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Publish New Insight',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Article Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Enter a title' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category (e.g. Finance, IT)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Enter a category' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _excerptController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Short Excerpt',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Enter an excerpt' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _contentController,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: 'Full Article Content',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Enter content' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isPublishing ? null : _publishArticle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isPublishing 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Publish to App', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
