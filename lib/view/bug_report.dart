import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> sendBugReport(String message, String contact) async {
  final url = Uri.parse('https://formspree.io/f/xeenedrl');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'message': message,
      'contact': contact,
      '_subject': 'Bug Reports',
    }),
  );

  return response.statusCode == 200;
}
class BugReportForm extends StatefulWidget {
  const BugReportForm({super.key});

  @override
  State<BugReportForm> createState() => _BugReportFormState();
}

class _BugReportFormState extends State<BugReportForm> {
  final _messageController = TextEditingController();
  final _contactController = TextEditingController();
  bool _isSending = false;

  void _submitForm() async {
    if (_messageController.text.isEmpty) return;

    setState(() => _isSending = true);

    bool success = await sendBugReport(
        _messageController.text,
        _contactController.text
    );

    setState(() => _isSending = false);

    if (success) {
      _messageController.clear();
      _contactController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Report sent to the caretaker! 🌿")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: MediaQuery.of(context).size.height*0.8,
        width: MediaQuery.of(context).size.width*0.4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 18),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment:MainAxisAlignment.end,children: [CloseButton()],),
              const Text("Report a Bug",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A5D4A))),
              const SizedBox(height: 8),
              const Text("Found a bug in the shed? Let us know.",
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 20),

              // Contact Field
              TextField(
                controller: _contactController,
                decoration: _inputStyle("Email (Optional)"),
              ),
              const SizedBox(height: 16),

              // Message Field
              TextField(
                controller: _messageController,
                maxLines: 4,
                decoration: _inputStyle("Describe what happened, where, how often, etc..."),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSending ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B8E6B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  child: _isSending
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Send Report", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.all(16),
    );
  }
}