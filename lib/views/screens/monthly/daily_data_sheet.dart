import 'package:flutter/material.dart';
import 'package:women_health/core/models/period_data.dart';

class DailyDataSheet extends StatefulWidget {
  final DateTime date;
  final DailyData? initialData; // Pass existing data to pre-fill the form
  final Function(DailyData) onSave;

  const DailyDataSheet({
    Key? key,
    required this.date,
    required this.onSave,
    this.initialData,
  }) : super(key: key);

  @override
  _DailyDataSheetState createState() => _DailyDataSheetState();
}

class _DailyDataSheetState extends State<DailyDataSheet> {
  // Local state for the form fields
  String _selectedMood = '';
  List<String> _selectedSymptoms = [];
  int _flow = 0;
  late TextEditingController _notesController;

  // Static options for the form
  final List<String> _moods = ['Happy', 'Sad', 'Anxious', 'Energetic', 'Tired', 'Irritable'];
  final List<String> _symptomsList = ['Cramps', 'Headache', 'Bloating', 'Acne', 'Breast tenderness', 'Fatigue'];

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();

    // Pre-fill the form if initial data is provided
    if (widget.initialData != null) {
      _selectedMood = widget.initialData!.mood;
      // Convert comma-separated string back to a list for the UI
      if (widget.initialData!.symptoms.isNotEmpty) {
        _selectedSymptoms = widget.initialData!.symptoms.split(', ').toList();
      }
      _flow = widget.initialData!.flow;
      _notesController.text = widget.initialData!.notes;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    final data = DailyData(
      mood: _selectedMood,
      // Join the list into a single comma-separated string for storage
      symptoms: _selectedSymptoms.join(', '),
      flow: _flow,
      notes: _notesController.text,
    );
    widget.onSave(data);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        // This pushes the content up when the keyboard appears
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Daily Log - ${widget.date.day}/${widget.date.month}/${widget.date.year}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('How are you feeling?'),
            Wrap(
              spacing: 8.0,
              children: _moods.map((mood) => FilterChip(
                label: Text(mood),
                selectedColor: Colors.pink.shade100,
                selected: _selectedMood == mood,
                onSelected: (selected) {
                  setState(() {
                    _selectedMood = selected ? mood : '';
                  });
                },
              )).toList(),
            ),
            const SizedBox(height: 16),

            _buildSectionTitle('Symptoms'),
            Wrap(
              spacing: 8.0,
              children: _symptomsList.map((symptom) => FilterChip(
                label: Text(symptom),
                selectedColor: Colors.pink.shade100,
                selected: _selectedSymptoms.contains(symptom),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedSymptoms.add(symptom);
                    } else {
                      _selectedSymptoms.remove(symptom);
                    }
                  });
                },
              )).toList(),
            ),
            const SizedBox(height: 16),

            _buildSectionTitle('Flow Intensity'),
            Slider(
              value: _flow.toDouble(),
              min: 0,
              max: 5,
              divisions: 5,
              label: _flow == 0 ? 'None' : _flow.toString(),
              activeColor: Colors.pink,
              inactiveColor: Colors.pink.shade100,
              onChanged: (value) {
                setState(() {
                  _flow = value.toInt();
                });
              },
            ),
            const SizedBox(height: 16),

            _buildSectionTitle('Notes'),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add any additional notes...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSavePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Log', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}