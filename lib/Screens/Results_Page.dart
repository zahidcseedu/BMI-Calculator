import 'dart:developer';

import 'package:bmi_calculator_app/Components/BottomContainer_Button.dart';
import 'package:bmi_calculator_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Components/Reusable_Bg.dart';
import '../Services/results_storage.dart';
import '../Widgets/BMI_Gauge.dart';

class ResultPage extends StatefulWidget {
  final String resultText;
  final String bmi;
  final String advise;
  final Color textColor;
  final int height;
  final int weight;
  final double bmiBmi;
  final String normalWeightRange;

  ResultPage(
      {required this.textColor,
      required this.resultText,
      required this.bmi,
      required this.advise,
      required this.height,
      required this.weight,
      required this.bmiBmi,
      required this.normalWeightRange});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  double _getBMIProgress() {
    // Scale BMI from 0 to 40 to 0 to 1
    // Underweight: 0-18.5, Normal: 18.5-25, Overweight: 25-40
    if (widget.bmiBmi < 0) return 0;
    if (widget.bmiBmi > 40) return 1;
    return widget.bmiBmi / 40;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2F51),
      appBar: AppBar(
        title: Center(
          child: Text('BMI CALCULATOR'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15.0),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'BMI = ${widget.bmi} kg/m²',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '(${widget.resultText})',
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: BMIGaugeWidget(
                bmi: widget.bmiBmi,
                status: widget.resultText,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      'Healthy BMI range:',
                      '18.5 - 25 kg/m²',
                    ),
                    SizedBox(height: 10.0),
                    _buildInfoRow(
                      'Healthy weight for the height:',
                      _normalWeightRangeInKg(),
                    ),
                    SizedBox(height: 10.0),
                    _buildInfoRow(
                      'Lose ${_amountToLose().toStringAsFixed(1)} kg',
                      'to reach a BMI of 25 kg/m².',
                    ),
                    SizedBox(height: 10.0),
                    _buildInfoRow(
                      'BMI Prime:',
                      (_bmiBmi() / 25).toStringAsFixed(2),
                    ),
                    SizedBox(height: 10.0),
                    _buildInfoRow(
                      'Ponderal Index:',
                      '${_ponderalIndex().toStringAsFixed(1)} kg/m³',
                    ),
                    SizedBox(height: 15.0),
                    Center(
                      child: RawMaterialButton(
                        onPressed: () {
                          debugger();
                          _saveResult();
                        },
                        constraints: BoxConstraints.tightFor(
                          width: 200.0,
                          height: 56.0,
                        ),
                        fillColor: Color(0xFFEB1555),
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          'SAVE RESULT',
                          style: kBodyTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BottomContainer(
              text: 'RE-CALCULATE',
              onTap: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF8D8E98),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  double _bmiBmi() {
    return widget.bmiBmi;
  }

  String _normalWeightRangeInKg() {
    final minWeightKg = 18.5 * (widget.height / 100) * (widget.height / 100);
    final maxWeightKg = 25 * (widget.height / 100) * (widget.height / 100);

    final minWeight = minWeightKg.toStringAsFixed(1);
    final maxWeight = maxWeightKg.toStringAsFixed(1);

    return '$minWeight - $maxWeight kg';
  }

  double _amountToLose() {
    final idealBMI = 25.0;
    final idealWeightKg =
        idealBMI * (widget.height / 100) * (widget.height / 100);
    final currentWeightKg = widget.weight;
    final diffKg = currentWeightKg - idealWeightKg;

    return diffKg > 0 ? diffKg : 0; // Return kg directly
  }

  double _ponderalIndex() {
    // PI = weight (kg) / height (m)³
    final heightInMeters = widget.height / 100;
    return widget.weight / (heightInMeters * heightInMeters * heightInMeters);
  }

  void _saveResult() async {
    final result = BMIResult(
      bmi: widget.bmi,
      status: widget.resultText,
      normalWeightRange: widget.normalWeightRange,
      savedDate: DateTime.now(),
    );

    await ResultsStorage.saveResult(result);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Result saved successfully!'),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFF24D876),
        ),
      );
    }
  }
}
