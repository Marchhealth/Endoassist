import 'package:flutter/material.dart';
import 'dart:html' as html;

class AnalysisProvider with ChangeNotifier {
  html.File? _selectedFile;
  bool _isProcessing = false;
  bool _isConfirmed = false;
  Map<String, dynamic>? _analysisResults;
  String? _previewUrl;
  String? _assistResponse;
  bool _isSurgeonConfirmed = false;
  bool _isWaitingForAssist = false;

  // Laparoscopy specific states
  html.File? _laparoscopyFile;
  String? _laparoscopyFileType;
  bool _laparoscopyProcessing = false;
  String? _laparoscopyPreviewUrl;
  Map<String, dynamic>? _laparoscopyResults;

  // Getters
  html.File? get selectedFile => _selectedFile;
  bool get isProcessing => _isProcessing;
  bool get isConfirmed => _isConfirmed;
  Map<String, dynamic>? get analysisResults => _analysisResults;
  String? get previewUrl => _previewUrl;
  String? get assistResponse => _assistResponse;
  bool get isSurgeonConfirmed => _isSurgeonConfirmed;
  bool get isWaitingForAssist => _isWaitingForAssist;

  html.File? get laparoscopyFile => _laparoscopyFile;
  String? get laparoscopyFileType => _laparoscopyFileType;
  bool get laparoscopyProcessing => _laparoscopyProcessing;
  String? get laparoscopyPreviewUrl => _laparoscopyPreviewUrl;
  Map<String, dynamic>? get laparoscopyResults => _laparoscopyResults;
  bool get isLaparoscopyProcessing => _laparoscopyProcessing;

  // Mock results
  final Map<String, dynamic> mockLaparoscopyResults = {
    'segmented_images': [
      'assets/Result-1.jpg',
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

  void setSelectedFile(html.File file) {
    _selectedFile = file;
    _previewUrl = html.Url.createObjectUrlFromBlob(file);
    notifyListeners();
  }

  void setAnalysisResults(Map<String, dynamic> results) {
    _analysisResults = results;
    notifyListeners();
  }

  void setAssistResponse(String response) {
    _assistResponse = response;
    notifyListeners();
  }

  void setSurgeonConfirmed(bool confirmed) {
    _isSurgeonConfirmed = confirmed;
    notifyListeners();
  }

  void setProcessing(bool processing) {
    _isProcessing = processing;
    notifyListeners();
  }

  void setConfirmed(bool confirmed) {
    _isConfirmed = confirmed;
    notifyListeners();
  }

  void setLaparoscopyFile(html.File file, String type, String previewUrl) {
    _laparoscopyFile = file;
    _laparoscopyFileType = type;
    _laparoscopyPreviewUrl = previewUrl;
    notifyListeners();
  }

  void setLaparoscopyProcessing(bool processing) {
    _laparoscopyProcessing = processing;
    notifyListeners();
  }

  void setLaparoscopyResults(Map<String, dynamic> results) {
    _laparoscopyResults = results;
    notifyListeners();
  }

  void setWaitingForAssist(bool waiting) {
    _isWaitingForAssist = waiting;
    notifyListeners();
  }

  void reset() {
    _selectedFile = null;
    _isProcessing = false;
    _isConfirmed = false;
    _analysisResults = null;
    _previewUrl = null;
    _assistResponse = null;
    _isSurgeonConfirmed = false;
    notifyListeners();
  }

  void resetLaparoscopy() {
    _laparoscopyFile = null;
    _laparoscopyFileType = null;
    _laparoscopyProcessing = false;
    _laparoscopyPreviewUrl = null;
    _laparoscopyResults = null;
    notifyListeners();
  }
}
