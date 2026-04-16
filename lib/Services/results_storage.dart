import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BMIResult {
  final String bmi;
  final String status;
  final String normalWeightRange;
  final DateTime savedDate;

  BMIResult({
    required this.bmi,
    required this.status,
    required this.normalWeightRange,
    required this.savedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'bmi': bmi,
      'status': status,
      'normalWeightRange': normalWeightRange,
      'savedDate': savedDate.toIso8601String(),
    };
  }

  factory BMIResult.fromMap(Map<String, dynamic> map) {
    return BMIResult(
      bmi: map['bmi'] ?? '',
      status: map['status'] ?? '',
      normalWeightRange: map['normalWeightRange'] ?? '',
      savedDate:
          DateTime.parse(map['savedDate'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class ResultsStorage {
  static const String _key = 'bmi_results';

  static Future<void> saveResult(BMIResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final results = await getResults();
    results.add(result);

    final jsonList = results.map((r) => jsonEncode(r.toMap())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  static Future<List<BMIResult>> getResults() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];

    return jsonList
        .map((json) {
          try {
            final map = jsonDecode(json) as Map<String, dynamic>;
            return BMIResult.fromMap(map);
          } catch (e) {
            return null;
          }
        })
        .whereType<BMIResult>()
        .toList();
  }

  static Future<void> clearResults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<void> deleteResult(BMIResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final results = await getResults();

    // Remove the result that matches the BMI, status, and date
    results.removeWhere((r) =>
        r.bmi == result.bmi &&
        r.status == result.status &&
        r.savedDate == result.savedDate);

    final jsonList = results.map((r) => jsonEncode(r.toMap())).toList();
    await prefs.setStringList(_key, jsonList);
  }
}
