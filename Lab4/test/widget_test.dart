import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_appointment_app/app.dart';

import 'test_data.dart';

void main() {
  testWidgets('shows API feed, empty search and appointment details', (
    tester,
  ) async {
    await tester.pumpWidget(
      MedicalAppointmentApp(repository: FakeMedicalRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(find.text('Nearby Doctor'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'missing doctor');
    await tester.pump();
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pump();
    expect(find.text('No doctors found'), findsOneWidget);

    await tester.tap(find.text('Clear filters'));
    await tester.pump();
    await tester.drag(find.byType(ListView), const Offset(0, 500));
    await tester.pump();

    await tester.tap(find.text('Appointment').first);
    await tester.pumpAndSettle();
    expect(find.text('Dr.Upul'), findsOneWidget);
    expect(find.text('Book an Appointment'), findsOneWidget);
  });
}
