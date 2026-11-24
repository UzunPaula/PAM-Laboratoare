import 'package:medical_appointment_app/data/datasources/medical_remote_data_source.dart';
import 'package:medical_appointment_app/domain/entities/appointment_details.dart';
import 'package:medical_appointment_app/domain/entities/feed.dart';
import 'package:medical_appointment_app/domain/repositories/medical_repository.dart';

class MedicalRepositoryImpl implements MedicalRepository {
  const MedicalRepositoryImpl(this._remoteDataSource);

  final MedicalRemoteDataSource _remoteDataSource;

  @override
  Future<Feed> getFeed() => _remoteDataSource.getFeed();

  @override
  Future<AppointmentDetails> getAppointmentDetails() {
    return _remoteDataSource.getAppointmentDetails();
  }
}
