import 'package:medical_appointment_app/domain/entities/appointment_details.dart';
import 'package:medical_appointment_app/domain/entities/feed.dart';

abstract interface class MedicalRepository {
  Future<Feed> getFeed();

  Future<AppointmentDetails> getAppointmentDetails();
}
