import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  final Map<String, String> patientData;

  const ProfileTab({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Patient Information",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildInfoRow("Name", patientData["name"] ?? "N/A"),
          _buildInfoRow("Date of Birth", patientData["dateOfBirth"] ?? "N/A"),
          _buildInfoRow("Primary Physician", patientData["physician"] ?? "N/A"),
          _buildInfoRow("CA-125 Level", patientData["ca125"] ?? "N/A"),
          _buildInfoRow("AMH Level", patientData["amh"] ?? "N/A"),
          const SizedBox(height: 16),
          const Text(
            "Symptoms",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            patientData["symptoms"]?.isNotEmpty == true
                ? patientData["symptoms"]!
                : "No Symptoms Selected",
            style: const TextStyle(fontSize: 16),
          ),
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
