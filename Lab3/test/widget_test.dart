import 'package:flutter/material.dart'
    show ListView, Offset, TextField, UniqueKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_appointment_app/app.dart';

void main() {
  testWidgets('loads JSON, handles empty search and opens details', (
    tester,
  ) async {
    await tester.pumpWidget(MedicalAppointmentApp(key: UniqueKey()));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));

    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(find.text('Health Services'), findsOneWidget);
    expect(find.text('Nearby Doctor'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'missing doctor');
    await tester.pump();
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pump();

    expect(find.text('No doctors found'), findsOneWidget);
    expect(find.text('Clear filters'), findsOneWidget);

    await tester.tap(find.text('Clear filters'));
    await tester.pump();
    await tester.drag(find.byType(ListView), const Offset(0, 500));
    await tester.pump();

    await tester.tap(find.text('Appointment').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Dr.Upul'), findsOneWidget);
    expect(find.text('Book an Appointment'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pump();
    await tester.tap(find.text('Dr. Sonja Litel'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Dr. Sonja Litel'), findsWidgets);
    expect(find.text('Dental Specialist'), findsWidgets);
    expect(find.text('Book an Appointment'), findsOneWidget);
  });
}
