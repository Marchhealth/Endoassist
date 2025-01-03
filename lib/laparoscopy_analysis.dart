import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'providers/analysis_provider.dart';

class LaparoscopyAnalysis extends StatefulWidget {
  const LaparoscopyAnalysis({super.key});

  @override
  State<LaparoscopyAnalysis> createState() => _LaparoscopyAnalysisState();
}

class _LaparoscopyAnalysisState extends State<LaparoscopyAnalysis> {
  late AnalysisProvider _provider;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<AnalysisProvider>(context, listen: false);
  }

  Future<void> _pickFile() async {
    final input = html.FileUploadInputElement()..accept = '.jpg,.mp4';
    input.click();

    await input.onChange.first;
    if (input.files!.isNotEmpty) {
      final file = input.files![0];
      final reader = html.FileReader();
      reader.readAsDataUrl(file);

      await reader.onLoad.first;
      _provider.setLaparoscopyFile(
        file,
        file.type,
        reader.result as String,
      );

      if (file.type.contains('video')) {
        _initializeVideoPlayer(reader.result as String);
      }
    }
  }

  Future<void> _initializeVideoPlayer(String url) async {
    _videoController = VideoPlayerController.network(url);
    await _videoController?.initialize();
    setState(() {});
  }

  Future<void> _processFile() async {
    if (_provider.laparoscopyFile == null) return;

    _provider.setLaparoscopyProcessing(true);

    await Future.delayed(const Duration(seconds: 15));

    _provider.setLaparoscopyResults(_provider.mockLaparoscopyResults);
    _provider.setLaparoscopyProcessing(false);
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
          if (_provider.laparoscopyFile != null) ...[
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
        color: Colors.blue[600],
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
              Icon(Icons.cloud_upload, size: 50, color: Colors.blue[600]),
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
      child: _provider.laparoscopyFileType?.contains('video') == true && _videoController != null
          ? AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            )
          : _provider.laparoscopyFileType?.contains('image') == true && _provider.laparoscopyPreviewUrl != null
              ? Image.network(_provider.laparoscopyPreviewUrl!, fit: BoxFit.contain)
              : const Center(child: Text('Preview not available')),
    );
  }

  Widget _buildProcessButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _provider.isLaparoscopyProcessing ? null : _processFile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _provider.isLaparoscopyProcessing
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Process File'),
      ),
    );
  }

  Widget _buildProcessedResult() {
    if (_provider.laparoscopyResults == null) return const SizedBox();
    
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
          for (String imagePath in _provider.laparoscopyResults!['segmented_images'])
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
            'Area Percentage: ${_provider.laparoscopyResults!['area_percentage']}%',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Severity: ${_provider.laparoscopyResults!['severity']}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Recommendations:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ..._provider.laparoscopyResults!['recommendations']
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
