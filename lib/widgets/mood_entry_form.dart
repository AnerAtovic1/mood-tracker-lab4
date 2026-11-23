import 'package:flutter/material.dart';

import '../models/mood_entry.dart';
import 'mood_score_selector.dart';

/// A form for recording a new mood entry.
///
/// Exercise 1, step 3, and Exercise 2, steps 1-3.
class MoodEntryForm extends StatefulWidget {
  const MoodEntryForm({super.key, required this.onSubmit});

  /// Called with the new entry when the user saves it.
  final ValueChanged<MoodEntry> onSubmit;

  @override
  State<MoodEntryForm> createState() => _MoodEntryFormState();
}

class _MoodEntryFormState extends State<MoodEntryForm> {
  int? _score;
  final TextEditingController _noteController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    final score = _score;
    if (score == null) {
      setState(() {
        _errorMessage = 'Choose a score from 1 to 10';
      });
      return;
    }

    if (_noteController.text.length > maxNoteLength) {
      setState(() {
        _errorMessage = 'Note must be at most 2000 characters';
      });
      return;
    }

    final note = _noteController.text.trim();
    widget.onSubmit(
      MoodEntry(
        score: score,
        note: note.isEmpty ? null : note,
        createdAt: DateTime.now(),
      ),
    );
    setState(() {
      _score = null;
      _errorMessage = null;
    });
    _noteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final errorMessage = _errorMessage;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'How are you feeling?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            MoodScoreSelector(
              selectedScore: _score,
              onChanged: (score) {
                setState(() {
                  _score = score;
                  _errorMessage = null;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Note (optional)'),
              onChanged: (_) {
                if (_errorMessage != null) {
                  setState(() {
                    _errorMessage = null;
                  });
                }
              },
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                errorMessage,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _save,
              child: const Text('Save entry'),
            ),
          ],
        ),
      ),
    );
  }
}
