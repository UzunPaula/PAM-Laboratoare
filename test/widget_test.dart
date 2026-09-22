import 'package:flutter_test/flutter_test.dart';
import 'package:medical_appointment_app/main.dart';

void main() {
  testWidgets('home screen opens appointment flow', (tester) async {
    await tester.pumpWidget(const MedicalAppointmentApp());

    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(find.text('Health Services'), findsOneWidget);
    expect(find.text('Nearby Doctor'), findsOneWidget);

    await tester.tap(find.text('Appointment').first);
    await tester.pumpAndSettle();

    expect(find.text('Dr.Upul'), findsOneWidget);
    expect(find.text('Book an Appointment'), findsOneWidget);
  });
}
