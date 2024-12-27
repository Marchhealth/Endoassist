import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageHelper {
  static const String _keyPatients = 'patients';

  // ذخیره داده‌های بیمار
  static Future<void> savePatientData(Map<String, String> patientData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedPatients = prefs.getStringList(_keyPatients) ?? [];
    storedPatients.add(jsonEncode(patientData));
    await prefs.setStringList(_keyPatients, storedPatients);
  }

  // بازیابی داده‌های بیماران
  static Future<List<Map<String, String>>> getPatientData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedPatients = prefs.getStringList(_keyPatients) ?? [];
    return storedPatients
        .map((patient) => Map<String, String>.from(jsonDecode(patient)))
        .toList();
  }

  // حذف تمام داده‌ها (برای تست یا ریست)
  static Future<void> clearPatientData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPatients);
  }
}
