import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BMIResult {
  final String bmi;
  final String status;
  final String normalWeightRange;
  final DateTime savedDate;
  final int height;
  final int weight;
  final String advice;
  final double bmiBmi;
  final String profileImagePath;

  BMIResult({
    required this.bmi,
    required this.status,
    required this.normalWeightRange,
    required this.savedDate,
    this.height = 0,
    this.weight = 0,
    this.advice = '',
    this.bmiBmi = 0.0,
    this.profileImagePath = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'bmi': bmi,
      'status': status,
      'normalWeightRange': normalWeightRange,
      'savedDate': savedDate.toIso8601String(),
      'height': height,
      'weight': weight,
      'advice': advice,
      'bmiBmi': bmiBmi,
      'profileImagePath': profileImagePath,
    };
  }

  factory BMIResult.fromMap(Map<String, dynamic> map) {
    return BMIResult(
      bmi: map['bmi'] ?? '',
      status: map['status'] ?? '',
      normalWeightRange: map['normalWeightRange'] ?? '',
      savedDate:
          DateTime.parse(map['savedDate'] ?? DateTime.now().toIso8601String()),
      height: map['height'] ?? 0,
      weight: map['weight'] ?? 0,
      advice: map['advice'] ?? '',
      bmiBmi: (map['bmiBmi'] ?? 0).toDouble(),
      profileImagePath: map['profileImagePath'] ?? '',
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
