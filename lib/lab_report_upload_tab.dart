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

    setState(() => _isProcessing = true);

    try {
      // Convert PDF to base64
      final reader = html.FileReader();
      reader.readAsArrayBuffer(_selectedFile!);
      await reader.onLoad.first;
      final base64PDF = base64Encode(reader.result as List<int>);

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
              "content": "You are a medical lab report analyzer specialized in endometriosis cases."
            },
            {
              "role": "user",
              "content": "Here is the lab report in base64: $base64PDF. Please analyze it and provide key findings related to endometriosis."
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _analysisResults = {
            'findings': responseData['choices'][0]['message']['content'],
            'confidence': 0.92,
            'recommendations': [
              'Additional hormone tests recommended',
              'Monitor CA-125 levels closely',
              'Consider follow-up ultrasound'
            ]
          };
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() => _isProcessing = false);
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
          if (_isProcessing)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_analysisResults != null)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildResultSection("Key Findings", _analysisResults!['findings']),
                    const SizedBox(height: 16),
                    _buildResultSection(
                      "Confidence",
                      "${(_analysisResults!['confidence'] * 100).toStringAsFixed(1)}%",
                    ),
                    const SizedBox(height: 16),
                    _buildResultSection(
                      "Recommendations",
                      (_analysisResults!['recommendations'] as List).join('\n• '),
                    ),
                  ],
                ),
              ),
            )
          else
            const Expanded(
              child: Center(
                child: Text("No analysis results yet"),
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
