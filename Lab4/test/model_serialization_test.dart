import 'package:flutter_test/flutter_test.dart';
import 'package:medical_appointment_app/data/models/appointment_details_model.dart';
import 'package:medical_appointment_app/data/models/feed_model.dart';

import 'test_data.dart';

void main() {
  test('deserializes and serializes feed JSON', () {
    final model = FeedModel.fromJson(feedJson());

    expect(model.nearbyDoctors, hasLength(2));
    expect(model.nearbyDoctors.last.serviceIds, ['tooth']);
    expect(model.toJson()['user'], containsPair('name', 'Jonathan'));
  });

  test('deserializes and serializes details JSON', () {
    final model = AppointmentDetailsModel.fromJson(detailsJson());

    expect(model.doctor.name, 'Dr.Upul');
    expect(model.workingHours.slots, hasLength(2));
    expect(model.toJson()['payment'], containsPair('amount', 120.0));
  });
}
