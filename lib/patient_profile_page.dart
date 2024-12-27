import 'package:flutter/material.dart';
import 'profile_tab.dart';
import 'classification_assistant_tab.dart';
import 'mri_upload_tab.dart';
import 'lab_report_upload_tab.dart';
import 'surgery_recommendation_tab.dart';

class PatientProfilePage extends StatefulWidget {
  final Map<String, String> patientData;

  const PatientProfilePage({super.key, required this.patientData});

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Patient Profile"),
          backgroundColor: Colors.black87,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Profile"),
              Tab(text: "Classification Assistant"),
              Tab(text: "MRI Upload"),
              Tab(text: "Lab Report Upload"),
              Tab(text: "Surgery Recommendation"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProfileTab(patientData: widget.patientData),
            const ClassificationAssistantTab(),
            const MriUploadTab(),
            const LabReportUploadTab(),
            SurgeryRecommendationTab(patientData: widget.patientData), // ارسال داده‌ها
          ],
        ),
      ),
    );
  }
}
