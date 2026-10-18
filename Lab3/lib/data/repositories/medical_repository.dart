import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:medical_appointment_app/data/models/medical_data.dart';

class MedicalRepository {
  MedicalRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  Future<MedicalData> loadMedicalData() async {
    final jsonText = await _bundle.loadString('assets/data/lab_v2.json');
    final decoded = jsonDecode(jsonText);

    if (decoded is! Map) {
      throw const FormatException('Radacina fisierului JSON este invalida.');
    }

    return MedicalData.fromJson(Map<String, dynamic>.from(decoded));
  }
}
