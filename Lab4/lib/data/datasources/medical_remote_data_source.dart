import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medical_appointment_app/core/constants/api_constants.dart';
import 'package:medical_appointment_app/core/errors/api_exception.dart';
import 'package:medical_appointment_app/data/models/appointment_details_model.dart';
import 'package:medical_appointment_app/data/models/feed_model.dart';

abstract interface class MedicalRemoteDataSource {
  Future<FeedModel> getFeed();

  Future<AppointmentDetailsModel> getAppointmentDetails();
}

class HttpMedicalRemoteDataSource implements MedicalRemoteDataSource {
  HttpMedicalRemoteDataSource(this._client);

  final http.Client _client;

  @override
  Future<FeedModel> getFeed() async {
    final json = await _getJson(ApiConstants.feedUrl);
    return FeedModel.fromJson(json);
  }

  @override
  Future<AppointmentDetailsModel> getAppointmentDetails() async {
    final json = await _getJson(ApiConstants.detailsUrl);
    return AppointmentDetailsModel.fromJson(json);
  }

  Future<Map<String, dynamic>> _getJson(String url) async {
    try {
      final response = await _client
          .get(Uri.parse(url), headers: const {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        throw ApiException(
          'Serverul a raspuns cu codul ${response.statusCode}.',
          statusCode: response.statusCode,
        );
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map) {
        throw const FormatException('Raspunsul API nu este un obiect JSON.');
      }
      return Map<String, dynamic>.from(decoded);
    } on TimeoutException {
      throw const ApiException('Cererea a durat prea mult. Incearca din nou.');
    } on http.ClientException {
      throw const ApiException(
        'Nu exista conexiune la server. Verifica internetul.',
      );
    }
  }
}
