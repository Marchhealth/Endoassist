import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class ClassificationAssistantTab extends StatefulWidget {
  final Function(Map<String, String>)? onConfirm;
  
  const ClassificationAssistantTab({super.key, this.onConfirm});

  @override
  State<ClassificationAssistantTab> createState() => _ClassificationAssistantTabState();
}

class _ClassificationAssistantTabState extends State<ClassificationAssistantTab> {
  List<html.File> selectedFiles = [];
  Map<String, dynamic>? aiResults;
  bool isLoading = false;
  bool isConfirmed = false;

  final List<Map<String, dynamic>> possibleResults = [
    {
      'classification': 'Stage I Endometriosis',
      'confidence': 0.75,
      'details': {
        'location': 'Pelvic region',
        'size': '1.2 cm',
        'severity': 'Mild',
      }
    },
    {
      'classification': 'Stage II Endometriosis',
      'confidence': 0.80,
      'details': {
        'location': 'Ovarian endometriomas',
        'size': '2.0 cm',
        'severity': 'Moderate',
      }
    },
    {
      'classification': 'Stage III Endometriosis',
      'confidence': 0.85,
      'details': {
        'location': 'Pelvic adhesions',
        'size': '3.0 cm',
        'severity': 'Moderate to Severe',
      }
    },
    {
      'classification': 'Stage IV Endometriosis',
      'confidence': 0.90,
      'details': {
        'location': 'Deep infiltrating endometriosis',
        'size': '4.5 cm',
        'severity': 'Severe',
      }
    },
    {
      'classification': 'Stage I Endometriosis',
      'confidence': 0.70,
      'details': {
        'location': 'Ovarian cysts',
        'size': '1.0 cm',
        'severity': 'Mild',
      }
    },
    {
      'classification': 'Stage II Endometriosis',
      'confidence': 0.78,
      'details': {
        'location': 'Pelvic adhesions',
        'size': '2.5 cm',
        'severity': 'Moderate',
      }
    },
    {
      'classification': 'Stage III Endometriosis',
      'confidence': 0.82,
      'details': {
        'location': 'Ovarian endometriomas',
        'size': '3.2 cm',
        'severity': 'Moderate to Severe',
      }
    },
    {
      'classification': 'Stage IV Endometriosis',
      'confidence': 0.88,
      'details': {
        'location': 'Deep infiltrating endometriosis',
        'size': '4.0 cm',
        'severity': 'Severe',
      }
    },
    {
      'classification': 'Stage I Endometriosis',
      'confidence': 0.72,
      'details': {
        'location': 'Pelvic region',
        'size': '1.5 cm',
        'severity': 'Mild',
      }
    },
    {
      'classification': 'Stage II Endometriosis',
      'confidence': 0.79,
      'details': {
        'location': 'Ovarian cysts',
        'size': '2.2 cm',
        'severity': 'Moderate',
      }
    },
    {
      'classification': 'Stage III Endometriosis',
      'confidence': 0.84,
      'details': {
        'location': 'Pelvic adhesions',
        'size': '3.1 cm',
        'severity': 'Moderate to Severe',
      }
    },
    {
      'classification': 'Stage IV Endometriosis',
      'confidence': 0.92,
      'details': {
        'location': 'Deep infiltrating endometriosis',
        'size': '4.8 cm',
        'severity': 'Severe',
      }
    },
    {
      'classification': 'Stage I Endometriosis',
      'confidence': 0.74,
      'details': {
        'location': 'Ovarian endometriomas',
        'size': '1.3 cm',
        'severity': 'Mild',
      }
    },
    {
      'classification': 'Stage II Endometriosis',
      'confidence': 0.77,
      'details': {
        'location': 'Pelvic region',
        'size': '2.1 cm',
        'severity': 'Moderate',
      }
    },
    {
      'classification': 'Stage III Endometriosis',
      'confidence': 0.83,
      'details': {
        'location': 'Ovarian cysts',
        'size': '3.3 cm',
        'severity': 'Moderate to Severe',
      }
    },
    {
      'classification': 'Stage IV Endometriosis',
      'confidence': 0.89,
      'details': {
        'location': 'Deep infiltrating endometriosis',
        'size': '4.2 cm',
        'severity': 'Severe',
      }
    },
    {
      'classification': 'Stage I Endometriosis',
      'confidence': 0.73,
      'details': {
        'location': 'Pelvic adhesions',
        'size': '1.4 cm',
        'severity': 'Mild',
      }
    },
    {
      'classification': 'Stage II Endometriosis',
      'confidence': 0.76,
      'details': {
        'location': 'Ovarian endometriomas',
        'size': '2.3 cm',
        'severity': 'Moderate',
      }
    },
    {
      'classification': 'Stage III Endometriosis',
      'confidence': 0.81,
      'details': {
        'location': 'Pelvic region',
        'size': '3.4 cm',
        'severity': 'Moderate to Severe',
      }
    },
    {
      'classification': 'Stage IV Endometriosis',
      'confidence': 0.87,
      'details': {
        'location': 'Deep infiltrating endometriosis',
        'size': '4.1 cm',
        'severity': 'Severe',
      }
    },
  ];

  Future<void> _pickFiles() async {
    final input = html.FileUploadInputElement()..accept = 'image/*'..multiple = true;
    input.click();

    await input.onChange.first;
    if (input.files!.isNotEmpty) {
      setState(() {
        selectedFiles = input.files!;
      });
    }
  }

  Future<void> _processImages() async {
    if (selectedFiles.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Simulate API call to AI model
      await Future.delayed(const Duration(seconds: 2));
      final random = Random();
      final randomResult = possibleResults[random.nextInt(possibleResults.length)];
      setState(() {
        aiResults = randomResult;
      });
    } catch (e) {
      // Handle error
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing images: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _confirmResults() {
    if (aiResults != null && widget.onConfirm != null) {
      final resultData = {
        'classification': aiResults!['classification'].toString(),
        'confidence': aiResults!['confidence'].toString(),
        'details': json.encode(aiResults!['details']),
        'confirmed': 'true',
      };
      
      widget.onConfirm!(resultData);
      setState(() {
        isConfirmed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Upload Box
          Expanded(
            flex: 1,
            child: _buildUploadBox(),
          ),
          const SizedBox(width: 24),
          // AI Analysis Results Box
          Expanded(
            flex: 1,
            child: _buildResultsBox(),
          ),
          const SizedBox(width: 24),
          // Confirmation Box
          Expanded(
            flex: 1,
            child: _buildConfirmationBox(),
          ),
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
          _buildBoxHeader("Upload MRI Images", Icons.upload_file),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload, size: 48, color: Colors.blue[300]),
                  const SizedBox(height: 16),
                  const Text("Drag and drop MRI images here"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _pickFiles,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text("Select Files"),
                  ),
                  if (selectedFiles.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text("${selectedFiles.length} files selected"),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _processImages,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text("Analyze Images"),
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
          _buildBoxHeader("AI Analysis Results", Icons.analytics),
          if (isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (aiResults != null)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildResultItem("Classification", aiResults!['classification']),
                    _buildResultItem("Confidence", "${(aiResults!['confidence'] * 100).toStringAsFixed(1)}%"),
                    const SizedBox(height: 16),
                    const Text("Details:", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...aiResults!['details'].entries.map((e) => 
                      _buildResultItem(e.key.toString().toUpperCase(), e.value.toString())
                    ).toList(),
                  ],
                ),
              ),
            )
          else
            const Expanded(
              child: Center(
                child: Text("No results available"),
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
          const Text("Are you sure you want to proceed with the analysis?"),
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

  Widget _buildResultItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}