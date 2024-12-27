import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'dart:convert';

class LabReportUploadTab extends StatefulWidget {
  const LabReportUploadTab({super.key});

  @override
  State<LabReportUploadTab> createState() => _LabReportUploadTabState();
}

class _LabReportUploadTabState extends State<LabReportUploadTab> {
  html.File? _selectedFile;
  bool _isProcessing = false;
  bool _isConfirmed = false;
  Map<String, dynamic>? _analysisResults;
  String? _previewUrl;
  String? _assistResponse;
  bool _isSurgeonConfirmed = false;
  bool _isWaitingForAssist = false;

  Future<void> _pickFile() async {
    final input = html.FileUploadInputElement()..accept = '.pdf';
    input.click();

    await input.onChange.first;
    if (input.files!.isNotEmpty) {
      setState(() {
        _selectedFile = input.files![0];
        _previewUrl = html.Url.createObjectUrlFromBlob(_selectedFile!);
      });
    }
  }

  Future<void> _processFile() async {
    if (_selectedFile == null) return;

    setState(() {
      _isProcessing = true;
      _isWaitingForAssist = true;
    });

    try {
      // Simulate API call to Assist
      await Future.delayed(const Duration(seconds: 3));
      
      // Mock response from Assist
      _assistResponse = '''
        Analysis Results:
        - CA-125 Level: 45 U/mL (Elevated)
        - Hormonal Imbalance Detected
        - Inflammatory Markers Present
        
        Severity Level: Moderate
        
        Recommended Actions:
        1. Further diagnostic imaging
        2. Hormonal therapy consideration
        3. Surgical evaluation recommended
      ''';

      setState(() {
        _analysisResults = {
          'findings': _assistResponse,
          'confidence': 0.89,
          'needsSurgeonConfirmation': true,
        };
        _isWaitingForAssist = false;
      });
    } catch (e) {
      debugPrint('Error: $e');
      // Show error in UI
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error processing file')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleSurgeonConfirmation() async {
    setState(() => _isSurgeonConfirmed = true);

    try {
      // Send confirmed analysis to Assist recommendation
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Analysis confirmed and sent for recommendations'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint('Error sending confirmation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error sending confirmation'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmResults() async {
    if (_analysisResults != null) {
      // Send to surgery recommendation assistant
      final response = await http.post(
        Uri.parse('https://marchv1.openai.azure.com/openai/deployments/gpt-4/chat/completions?api-version=2024-02-15-preview'),
        headers: {
          'Content-Type': 'application/json',
          'api-key': 'b12a39b621964269a0da06699f814f01',
        },
        body: jsonEncode({
          "messages": [
            {
              "role": "system",
              "content": "Consider this lab analysis for surgery recommendation"
            },
            {
              "role": "user",
              "content": jsonEncode(_analysisResults)
            }
          ]
        }),
      );
      
      setState(() => _isConfirmed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: _buildUploadBox()),
          const SizedBox(width: 24),
          Expanded(flex: 1, child: _buildResultsBox()),
          const SizedBox(width: 24),
          Expanded(flex: 1, child: _buildConfirmationBox()),
        ],
      ),
    );
  }

  Widget _buildUploadBox() {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildBoxHeader("Upload Lab Report", Icons.upload_file),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.picture_as_pdf, size: 48, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  const Text("Upload PDF lab report"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _pickFile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text("Select PDF"),
                  ),
                  if (_selectedFile != null) ...[
                    const SizedBox(height: 16),
                    Text("Selected: ${_selectedFile!.name}"),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _processFile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text("Analyze Report"),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsBox() {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildBoxHeader("Analysis Results", Icons.analytics),
          if (_isProcessing || _isWaitingForAssist)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Analyzing report..."),
                  ],
                ),
              ),
            )
          else if (_analysisResults != null)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildResultSection("Analysis from Assist", _assistResponse ?? ""),
                    const SizedBox(height: 16),
                    _buildResultSection(
                      "Confidence Score",
                      "${(_analysisResults!['confidence'] * 100).toStringAsFixed(1)}%",
                    ),
                    const SizedBox(height: 24),
                    if (!_isSurgeonConfirmed)
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _handleSurgeonConfirmation,
                          icon: const Icon(Icons.check_circle),
                          label: const Text("Confirm Analysis as Surgeon"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    if (_isSurgeonConfirmed)
                      const Center(
                        child: Text(
                          "✓ Analysis confirmed by surgeon",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
          else
            const Expanded(
              child: Center(
                child: Text("Upload a report to see analysis"),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConfirmationBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildBoxHeader("Confirm Analysis", Icons.check_circle),
          const SizedBox(height: 16),
          Text(
            _isConfirmed
                ? "Analysis confirmed and sent to surgery recommendation"
                : "Review the analysis results and confirm if accurate",
          ),
          if (_analysisResults != null && !_isConfirmed) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _confirmResults,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text("Confirm Results"),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBoxHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue[600]),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildResultSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
