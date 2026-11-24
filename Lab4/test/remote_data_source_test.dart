import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:medical_appointment_app/core/errors/api_exception.dart';
import 'package:medical_appointment_app/data/datasources/medical_remote_data_source.dart';

import 'test_data.dart';

void main() {
  test('GET requests deserialize feed and details', () async {
    final client = MockClient((request) async {
      final body = request.url.path.endsWith('/details')
          ? detailsJson()
          : feedJson();
      return http.Response(jsonEncode(body), 200);
    });
    final dataSource = HttpMedicalRemoteDataSource(client);

    final feed = await dataSource.getFeed();
    final details = await dataSource.getAppointmentDetails();

    expect(feed.user.name, 'Jonathan');
    expect(details.payment.amount, 120);
  });

  test('non-200 response throws ApiException', () async {
    final client = MockClient((_) async => http.Response('Server error', 500));
    final dataSource = HttpMedicalRemoteDataSource(client);

    expect(dataSource.getFeed(), throwsA(isA<ApiException>()));
  });
}
