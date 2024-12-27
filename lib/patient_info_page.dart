import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class PatientInfoPage extends StatefulWidget {
  final Function(Map<String, String>) onSave;

  const PatientInfoPage({super.key, required this.onSave});

  @override
  State<PatientInfoPage> createState() => _PatientInfoPageState();
}

class _PatientInfoPageState extends State<PatientInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, bool> symptomsState = {};

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController physicianController = TextEditingController();
  final TextEditingController ca125Controller = TextEditingController();
  final TextEditingController amhController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text(
            "Patient Information",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Medical History"),
              Tab(text: "Symptoms"),
            ],
          ),
        ),
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  _buildMedicalHistoryTab(),
                  _buildSymptomsTab(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _savePatientData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalHistoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Medical and Symptom History",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildTextField("Full Name", controller: nameController),
          _buildDateField("Date of Birth", controller: dateOfBirthController),
          _buildTextField("Primary Physician", controller: physicianController),
          _buildTextField("CA-125 Level", controller: ca125Controller),
          _buildTextField("AMH Level", controller: amhController),
          _buildTextField("Initial Diagnosis", controller: diagnosisController),
          _buildTextField("Surgical History", maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildSymptomsTab() {
    final symptoms = [
      "Menstrual Pain (Dysmenorrhea)",
      "Cramping",
      "Fatigue/Chronic Fatigue",
      "Heavy/Extreme Menstrual Bleeding",
      "Pelvic Pain",
      "Painful Ovulation",
      "Nausea",
      "Pain During Intercourse",
      "Sharp/Stabbing Pain",
      "Bloating",
      "Headaches",
      "Back Pain",
      "Painful Bowel Movements",
      "IBS-like Symptoms",
      "Irregular/Missed Periods",
      "Anemia/Iron Deficiency",
      "Severe Pain",
      "Hormonal Problems",
      "Digestive/GI Problems",
      "Insomnia/Sleeplessness",
      "Infertility",
      "Acne/Pimples",
      "Mood Swings",
      "Leg Pain",
      "Vomiting",
      "Constant Bleeding",
      "Abnormal Uterine Bleeding",
      "Fever",
      "Syncope (Fainting)",
      "Hip Pain",
      "Lower Back Pain",
    ];

    for (var symptom in symptoms) {
      symptomsState.putIfAbsent(symptom, () => false);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: symptoms.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text(symptoms[index]),
          value: symptomsState[symptoms[index]],
          onChanged: (bool? value) {
            setState(() {
              symptomsState[symptoms[index]] = value ?? false;
            });
          },
        );
      },
    );
  }

  Widget _buildTextField(String label,
      {TextEditingController? controller,
      TextInputType keyboardType = TextInputType.text,
      int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, {TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            setState(() {
              controller?.text = DateFormat('yyyy-MM-dd').format(pickedDate);
            });
          }
        },
      ),
    );
  }

  void _savePatientData() {
    final patientData = {
      "name": nameController.text,
      "dateOfBirth": dateOfBirthController.text,
      "physician": physicianController.text,
      "ca125": ca125Controller.text,
      "amh": amhController.text,
      "diagnosis": diagnosisController.text,
      "symptoms": symptomsState.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList()
          .join(", "),
    };

    widget.onSave(patientData);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Patient data saved successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Navigate back to the dashboard
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
