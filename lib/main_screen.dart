class MainScreen extends StatefulWidget {
  // ...existing code...
}

class _MainScreenState extends State<MainScreen> {
  late final Map<String, String> patientData;
  late final SurgeryRecommendationTab _surgeryTab;
  
  @override
  void initState() {
    super.initState();
    patientData = {
      'name': 'Patient Name',
      'dateOfBirth': '1990-01-01',
      'diagnosis': 'Initial Diagnosis',
      'ca125': '35',
      'amh': '2.5',
      'symptoms': 'Chronic pelvic pain, heavy menstrual bleeding',
    };

    _surgeryTab = SurgeryRecommendationTab(
      key: const ValueKey('surgery_tab'),
      patientData: patientData,
    );
  }

  void _handleClassificationComplete(Map<String, String> results) {
    final message = """
New Classification Results:
Classification: ${results['classification']}
Confidence: ${results['confidence']}
Details: ${results['details']}

Please analyze these results and provide updated surgery recommendations.
""";
    _surgeryTab.addMessageToChat(message);
    // Switch to surgery tab after sending result
    DefaultTabController.of(context).animateTo(2); // Adjust index as needed
  }

  void _handleLabReportComplete(Map<String, String> results) {
    final message = """
New Lab Report Results:
Findings: ${results['findings']}
Confidence: ${results['confidence']}
Needs Surgeon Confirmation: ${results['needsSurgeonConfirmation']}

Please analyze these results and provide updated surgery recommendations.
""";
    _surgeryTab.addMessageToChat(message);
    // Switch to surgery tab after sending result
    DefaultTabController.of(context).animateTo(2); // Adjust index as needed
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        // ...existing code...
        body: TabBarView(
          children: [
            // ...other tabs...
            ClassificationAssistantTab(
              onConfirm: _handleClassificationComplete,
            ),
            LabReportUploadTab(
              onConfirm: _handleLabReportComplete,
            ),
            _surgeryTab,
            // ...other tabs...
          ],
        ),
      ),
    );
  }
}
