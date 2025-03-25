import 'package:flutter/material.dart';
import '../services/form_service.dart';

class SavedDataScreen extends StatelessWidget {
  const SavedDataScreen({super.key});

  Widget _buildResponseItem(String key, dynamic value) {
    String questionText = 'Unknown Question';
    if (key == '72')
      questionText = 'Name of the customer';
    else if (key == '74')
      questionText = 'Contact number';
    else if (key == '75')
      questionText = 'Purpose of meeting';
    else if (key == '76')
      questionText = 'Reference name';
    else if (key == '95')
      questionText = 'Reference contact number';
    else if (key == '77')
      questionText = 'Remarks';
    else if (key == '90')
      questionText = 'Remarks';
    else if (key == '91')
      questionText = 'Type of activity conducted';
    else if (key == '71')
      questionText = 'Location';
    else if (key == '70')
      questionText = 'Selfie';

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$questionText: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            value?.toString() ?? 'Not answered',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Data'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: FormService.getAllSavedForms(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No saved data found.'));
            }
            final savedForms = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: savedForms.length,
              itemBuilder: (context, index) {
                final form = savedForms[index];
                final Map<String, dynamic> responses =
                    Map<String, dynamic>.from(form['responses']);
                final List<Widget> rows = [];

                final entries = responses.entries.toList();
                for (int i = 0; i < entries.length; i += 2) {
                  final List<Widget> rowChildren = [];

                  rowChildren.add(
                    _buildResponseItem(entries[i].key, entries[i].value),
                  );

                  if (i + 1 < entries.length) {
                    rowChildren.addAll([
                      const SizedBox(width: 16),
                      _buildResponseItem(
                        entries[i + 1].key,
                        entries[i + 1].value,
                      ),
                    ]);
                  }

                  rows.add(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: rowChildren,
                      ),
                    ),
                  );
                }

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Form: ${form['formUuid']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...rows,
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
