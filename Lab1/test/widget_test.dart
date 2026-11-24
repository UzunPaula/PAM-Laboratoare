import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laborator1_calculator_imc/main.dart';

void main() {
  testWidgets('calculeaza IMC si afiseaza categoria corecta', (tester) async {
    await tester.pumpWidget(const MyApp());

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '70');
    await tester.enterText(fields.at(1), '175');
    await tester.tap(find.text('CALCULEAZĂ'));
    await tester.pump();

    expect(find.text('IMC: 22.86'), findsOneWidget);
    expect(find.text('Greutate normală'), findsOneWidget);
  });

  testWidgets('valideaza valorile incorecte', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('CALCULEAZĂ'));
    await tester.pump();

    expect(find.text('Introdu valori corecte'), findsOneWidget);
  });
}
