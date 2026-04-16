import 'package:flutter/material.dart';
import '../constants.dart';
import '../Services/results_storage.dart';

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
              return Stack(
                children: [
                  Card(
                    color: Color(0xFF1B5E7E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            result.bmi,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            result.status,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: result.status == 'NORMAL'
                                  ? Color(0xFF24D876)
                                  : Colors.deepOrangeAccent,
                            ),
                          ),
                          Text(
                            result.normalWeightRange,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF8D8E98),
                            ),
                          ),
                          Text(
                            _formatDate(result.savedDate),
                            style: TextStyle(
                              fontSize: 10,
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
                      onTap: () {
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
