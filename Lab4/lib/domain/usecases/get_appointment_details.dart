import 'package:medical_appointment_app/domain/entities/appointment_details.dart';
import 'package:medical_appointment_app/domain/repositories/medical_repository.dart';

class GetAppointmentDetails {
  const GetAppointmentDetails(this._repository);

  final MedicalRepository _repository;

  Future<AppointmentDetails> call() => _repository.getAppointmentDetails();
}
