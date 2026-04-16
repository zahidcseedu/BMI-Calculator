import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../constants.dart';
import '../Services/results_storage.dart';
import 'Results_Page.dart';

class SavedResultsPage extends StatefulWidget {
  @override
  State<SavedResultsPage> createState() => _SavedResultsPageState();
}

class _SavedResultsPageState extends State<SavedResultsPage> {
  late Future<List<BMIResult>> _resultsFuture;

  @override
  void initState() {
    super.initState();
    _resultsFuture = ResultsStorage.getResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2F51),
      appBar: AppBar(
        title: Text('Saved Results'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () {
              _showClearDialog(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<BMIResult>>(
        future: _resultsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading results'));
          }

          final results = snapshot.data ?? [];

          if (results.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 60, color: Color(0xFF8D8E98)),
                  SizedBox(height: 20),
                  Text(
                    'No saved results yet',
                    style: TextStyle(
                      color: Color(0xFF8D8E98),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.all(12.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 1,
            ),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result =
                  results[results.length - 1 - index]; // Show newest first
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  debugPrint('Tapped on result: ${result.bmi}');
                  // Navigate to ResultPage with the saved result data
                  File? profileImage;
                  if (result.profileImagePath.isNotEmpty &&
                      File(result.profileImagePath).existsSync()) {
                    profileImage = File(result.profileImagePath);
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultPage(
                        bmi: result.bmi,
                        resultText: result.status,
                        advise: result.advice,
                        textColor: _getColorForStatus(result.status),
                        height: result.height,
                        weight: result.weight,
                        bmiBmi: result.bmiBmi,
                        normalWeightRange: result.normalWeightRange,
                        isSavedResult: true,
                        profileImage: profileImage,
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Card(
                      color: Color(0xFF1B5E7E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (result.profileImagePath.isNotEmpty &&
                                File(result.profileImagePath).existsSync())
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: FileImage(
                                          File(result.profileImagePath)),
                                      fit: BoxFit.cover,
                                    ),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            Text(
                              result.bmi,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              result.status,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: result.status == 'NORMAL'
                                    ? Color(0xFF24D876)
                                    : Colors.deepOrangeAccent,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              result.normalWeightRange,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF8D8E98),
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              _formatDate(result.savedDate),
                              style: TextStyle(
                                fontSize: 9,
                                color: Color(0xFF8D8E98),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          debugPrint('Delete button tapped');
                          _showDeleteDialog(context, result);
                        },
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.deepOrangeAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Color _getColorForStatus(String status) {
    if (status == 'NORMAL') {
      return Color(0xFF24D876);
    } else {
      return Colors.deepOrangeAccent;
    }
  }

  void _showDeleteDialog(BuildContext context, BMIResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete this result?'),
        content: Text('BMI ${result.bmi} - ${result.status}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ResultsStorage.deleteResult(result);
              Navigator.pop(context);
              setState(() {
                _resultsFuture = ResultsStorage.getResults();
              });
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear all results?'),
        content: Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ResultsStorage.clearResults();
              Navigator.pop(context);
              setState(() {
                _resultsFuture = ResultsStorage.getResults();
              });
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
