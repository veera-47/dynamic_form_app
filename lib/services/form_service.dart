import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/form_model.dart';

class FormService {
  static Future<FormData> loadForm(String jsonPath) async {
    final String jsonString = await rootBundle.loadString(jsonPath);
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    return FormData.fromJson(jsonData['data']);
  }

  static Future<void> saveFormData(
    String formUuid,
    Map<String, dynamic> data,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final savedForms = prefs.getStringList('saved_forms') ?? [];
    savedForms.add(
      jsonEncode({
        'formUuid': formUuid,
        'responses': data,
        'timestamp': DateTime.now().toIso8601String(),
      }),
    );
    await prefs.setStringList('saved_forms', savedForms);

    print('Saved form data: $savedForms');
  }

  static Future<List<Map<String, dynamic>>> getAllSavedForms() async {
    final prefs = await SharedPreferences.getInstance();
    final savedForms = prefs.getStringList('saved_forms') ?? [];

    print('Retrieved saved forms: $savedForms');
    final forms =
        savedForms
            .map((form) => jsonDecode(form) as Map<String, dynamic>)
            .toList();
    forms.sort(
      (a, b) => DateTime.parse(
        b['timestamp'],
      ).compareTo(DateTime.parse(a['timestamp'])),
    );
    return forms;
  }
}
