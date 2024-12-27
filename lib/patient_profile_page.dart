import 'package:flutter/material.dart';
import 'package:endometriosis_web/classification_assistant_tab.dart';
import 'package:endometriosis_web/surgery_recommendation_tab.dart';
import 'package:endometriosis_web/lab_report_upload_tab.dart';
import 'package:endometriosis_web/laparoscopy_analysis.dart';

class PatientProfilePage extends StatelessWidget {
  final Map<String, String> patientData;

  const PatientProfilePage({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text(
            "Patient Profile",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Overview"),
              Tab(text: "Details"),
              Tab(text: "Classification Assistant"),
              Tab(text: "Surgery Recommendation"),
              Tab(text: "Lab Reports"),
              Tab(text: "Laparoscopy Analysis"),
            ],
          ),
        ),
        backgroundColor: Colors.grey[200],
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildDetailsTab(),
            const ClassificationAssistantTab(),
            SurgeryRecommendationTab(patientData: patientData),
            const LabReportUploadTab(),
            const LaparoscopyAnalysis(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 20),
          _buildProfileInfo(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: Colors.blueAccent),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                patientData['name'] ?? "Unknown",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                "Age: ${_calculateAge(patientData['dateOfBirth'] ?? '')}",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                "Diagnosis: ${patientData['diagnosis'] ?? 'No Diagnosis'}",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Patient Information",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          _buildInfoRow("Full Name", patientData['name'] ?? "Unknown"),
          _buildInfoRow("Date of Birth", patientData['dateOfBirth'] ?? "Unknown"),
          _buildInfoRow("Primary Physician", patientData['physician'] ?? "Unknown"),
          _buildInfoRow("CA-125 Level", patientData['ca125'] ?? "Unknown"),
          _buildInfoRow("AMH Level", patientData['amh'] ?? "Unknown"),
          _buildInfoRow("Symptoms", patientData['symptoms'] ?? "None"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detailed Information",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          _buildInfoRow("Full Name", patientData['name'] ?? "Unknown"),
          _buildInfoRow("Date of Birth", patientData['dateOfBirth'] ?? "Unknown"),
          _buildInfoRow("Primary Physician", patientData['physician'] ?? "Unknown"),
          _buildInfoRow("CA-125 Level", patientData['ca125'] ?? "Unknown"),
          _buildInfoRow("AMH Level", patientData['amh'] ?? "Unknown"),
          _buildInfoRow("Initial Diagnosis", patientData['diagnosis'] ?? "Unknown"),
          _buildInfoRow("Symptoms", patientData['symptoms'] ?? "None"),
          const SizedBox(height: 20),
          const Text(
            "Surgical History",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Text(
            patientData['surgicalHistory'] ?? "No surgical history available.",
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  int _calculateAge(String dateOfBirth) {
    if (dateOfBirth.isEmpty) return 0;
    final dob = DateTime.parse(dateOfBirth);
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }
}
