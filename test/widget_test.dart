import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_tracker/data/sample_entries.dart';
import 'package:mood_tracker/main.dart';
import 'package:mood_tracker/models/mood_entry.dart';
import 'package:mood_tracker/widgets/mood_card.dart';

/// Renders the app in a window tall enough for every card to be built.
Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(400, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MoodTrackerApp());
}

Finder get saveButton => find.widgetWithText(FilledButton, 'Save entry');

Future<void> chooseScore(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(ChoiceChip, '3'));
  await tester.pump();
}

void main() {
  testWidgets('saving without a score shows an error and adds no entry',
      (tester) async {
    await pumpApp(tester);

    expect(tester.widget<FilledButton>(saveButton).onPressed, isNotNull);

    await tester.tap(saveButton);
    await tester.pump();

    expect(find.text('Choose a score from 1 to 10'), findsOneWidget);
    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length));
  });

  testWidgets('a note over 2000 characters shows an error and adds no entry',
      (tester) async {
    await pumpApp(tester);
    await chooseScore(tester);
    await tester.enterText(
      find.byType(TextField),
      List.filled(maxNoteLength + 1, 'a').join(),
    );

    await tester.tap(saveButton);
    await tester.pump();

    expect(find.text('Note must be at most 2000 characters'), findsOneWidget);
    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length));
  });

  testWidgets('a 2000-character note is accepted', (tester) async {
    await pumpApp(tester);
    await chooseScore(tester);
    final note = List.filled(maxNoteLength, 'a').join();
    await tester.enterText(find.byType(TextField), note);

    await tester.tap(saveButton);
    await tester.pump();

    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length + 1));
    expect(find.text(note), findsOneWidget);
    expect(find.text('Note must be at most 2000 characters'), findsNothing);
  });

  testWidgets('saving with an empty note adds an entry without an error',
      (tester) async {
    await pumpApp(tester);
    await chooseScore(tester);

    await tester.tap(saveButton);
    await tester.pump();

    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length + 1));
    expect(
      find.descendant(
        of: find.byType(MoodCard).first,
        matching: find.text('No note'),
      ),
      findsOneWidget,
    );
    expect(find.text('Choose a score from 1 to 10'), findsNothing);
    expect(find.text('Note must be at most 2000 characters'), findsNothing);
  });

  testWidgets('saving an entry puts it at the top of the history',
      (tester) async {
    await pumpApp(tester);

    await chooseScore(tester);
    await tester.enterText(find.byType(TextField), 'Rainy walk home');
    await tester.tap(saveButton);
    await tester.pump();

    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length + 1));
    expect(
      find.descendant(
        of: find.byType(MoodCard).first,
        matching: find.text('Rainy walk home'),
      ),
      findsOneWidget,
    );
  });
}
