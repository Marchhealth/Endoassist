import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:video_player/video_player.dart';
import 'dart:convert';

class LaparoscopyAnalysis extends StatefulWidget {
  const LaparoscopyAnalysis({super.key});

  @override
  State<LaparoscopyAnalysis> createState() => _LaparoscopyAnalysisState();
}

class _LaparoscopyAnalysisState extends State<LaparoscopyAnalysis> {
  html.File? _selectedFile;
  String? _selectedFileType;
  bool _isProcessing = false;
  VideoPlayerController? _videoController;
  String? _previewUrl;
  Map<String, dynamic>? _analysisResults;

  // Update mock results with local image paths
  final Map<String, dynamic> _mockResults = {
    'segmented_images': [
      'assets/Result-1.jpg',  // Make sure these images exist in assets
      'assets/Result-2.jpg'
    ],
    'area_percentage': 35.8,
    'severity': 'Moderate',
    'recommendations': [
      'Regular monitoring recommended',
      'Consider hormonal therapy',
      'Schedule follow-up in 3 months'
    ]
  };

  Future<void> _pickFile() async {
    final html.FileUploadInputElement input = html.FileUploadInputElement()
      ..accept = '.jpg,.mp4';
    input.click();

    await input.onChange.first;
    if (input.files!.isNotEmpty) {
      final file = input.files![0];
      final reader = html.FileReader();
      reader.readAsDataUrl(file);

      await reader.onLoad.first;
      setState(() {
        _selectedFile = file;
        _selectedFileType = file.type;
        _previewUrl = reader.result as String;
        
        if (_selectedFileType!.contains('video')) {
          _initializeVideoPlayer();
        }
      });
    }
  }

  Future<void> _initializeVideoPlayer() async {
    if (_previewUrl != null) {
      _videoController = VideoPlayerController.network(_previewUrl!);
      await _videoController!.initialize();
      setState(() {});
    }
  }

  Future<void> _processFile() async {
    if (_selectedFile == null) return;

    setState(() => _isProcessing = true);

    // Show loading for 15 seconds
    await Future.delayed(const Duration(seconds: 15));

    setState(() {
      _isProcessing = false;
      _analysisResults = _mockResults;  // Show predefined results
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildUploadSection(),
          if (_selectedFile != null) ...[
            const SizedBox(height: 20),
            _buildPreview(),
            const SizedBox(height: 20),
            _buildProcessButton(),
            const SizedBox(height: 20),
            _buildProcessedResult(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo[600],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.medical_services, color: Colors.white),
          SizedBox(width: 10),
          Text(
            'Laparoscopy Analysis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return InkWell(
      onTap: _pickFile,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload, size: 50, color: Colors.indigo[600]),
              const SizedBox(height: 10),
              const Text('Click to upload video (mp4) or image (jpg)'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: _selectedFileType?.contains('video') == true && _videoController != null
          ? AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            )
          : _selectedFileType?.contains('image') == true && _previewUrl != null
              ? Image.network(_previewUrl!, fit: BoxFit.contain)
              : const Center(child: Text('Preview not available')),
    );
  }

  Widget _buildProcessButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processFile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo[600],
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isProcessing
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Process File'),
      ),
    );
  }

  Widget _buildProcessedResult() {
    if (_analysisResults == null) return const SizedBox();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analysis Results',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // Display mock result images
          for (String imagePath in _analysisResults!['segmented_images'])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                height: 200,
              ),
            ),
          const SizedBox(height: 16),
          Text(
            'Area Percentage: ${_analysisResults!['area_percentage']}%',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Severity: ${_analysisResults!['severity']}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Recommendations:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ..._analysisResults!['recommendations']
              .map((r) => Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('• $r'),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
