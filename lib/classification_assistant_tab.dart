import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClassificationAssistantTab extends StatefulWidget {
  final Function(Map<String, String>)? onConfirm;
  
  const ClassificationAssistantTab({super.key, this.onConfirm});

  @override
  State<ClassificationAssistantTab> createState() => _ClassificationAssistantTabState();
}

class _ClassificationAssistantTabState extends State<ClassificationAssistantTab> {
  List<String> selectedFiles = [];
  Map<String, dynamic>? aiResults;
  bool isLoading = false;
  bool isConfirmed = false;

  Future<void> _processImages() async {
    setState(() {
      isLoading = true;
    });

    try {
      // TODO: Implement actual API call to AI model
      // Simulating API response
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        aiResults = {
          'classification': 'Stage III Endometriosis',
          'confidence': 0.89,
          'details': {
            'location': 'Ovarian endometriomas',
            'size': '3.5 cm',
            'severity': 'Moderate to Severe',
          }
        };
      });
    } catch (e) {
      // Handle error
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
          // const SizedBox(width: 24),
          // // Confirmation Box
          // Expanded(
          //   flex: 1,
          //   child: _buildConfirmationBox(),
          // ),
        ],
      ),
    );
  }

  Widget _buildUploadBox() {
    return Container(
      height: 500,
      padding: EdgeInsets.all(16),
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
                  Icon(Icons.cloud_upload, size: 48, color: Colors.indigo[300]),
                  const SizedBox(height: 16),
                  const Text("Drag and drop MRI images here"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement file selection
                      _processImages();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text("Select Files",style: TextStyle(color: Colors.white,fontSize: 12),),
                  ),
                  if (selectedFiles.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text("${selectedFiles.length} files selected"),
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
      padding: EdgeInsets.all(16),
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
                      _buildResultItem(e.key.toString().toUpperCase(), e.value)
                    ),
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
        ],
      ),
    );
  }

  Widget _buildBoxHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo[600]),
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
              color: Colors.indigo,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}