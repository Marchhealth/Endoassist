import 'package:flutter/material.dart';
import 'package:endometriosis_web/patient_info_page.dart';
import 'package:endometriosis_web/patient_profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Map<String, String>> patients = []; // ذخیره اطلاعات بیماران

  // اضافه کردن بیمار به لیست
  void addPatient(Map<String, String> patientData) {
    setState(() {
      patients.add(patientData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeMessage(),
              const SizedBox(height: 20),
              _buildQuickActions(),
              const SizedBox(height: 20),
              const Text(
                "Patients Overview",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              _buildPatientsList(),
              const SizedBox(height: 10),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage() {
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
      child: const Text(
        "Welcome to Endometriosis Assist",
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionCard(
          context,
          "Enter Patient Info",
          Icons.person_add,
          PatientInfoPage(onSave: addPatient), // ذخیره اطلاعات بیمار
        ),
        // _buildActionCard(
        //   context,
        //   "Assessment Tools",
        //   Icons.analytics,
        //   const Placeholder(), // این بخش فعلا خالی است
        // ),
      ],
    );
  }

  Widget _buildPatientsList() {
    return Container(
      height: 300,
      child: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];
          return _buildPatientCard(
            patient['name'] ?? "Unknown",
            "Age: ${_calculateAge(patient['dateOfBirth'] ?? '')}, Diagnosis: ${patient['diagnosis'] ?? 'No Diagnosis'}",
            patient,
          );
        },
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

  Widget _buildPatientCard(String title, String subtitle, Map<String, String> patientData) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        leading: const Icon(Icons.person, color: Colors.blueAccent, size: 36),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.black54),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
        onTap: () {
          // ارسال کل داده‌های بیمار به صفحه PatientProfilePage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientProfilePage(patientData: patientData),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.blueAccent),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        ),
        child: const Text("Log Out", style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
