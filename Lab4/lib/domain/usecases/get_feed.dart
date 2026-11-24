import 'package:medical_appointment_app/domain/entities/feed.dart';
import 'package:medical_appointment_app/domain/repositories/medical_repository.dart';

class GetFeed {
  const GetFeed(this._repository);

  final MedicalRepository _repository;

  Future<Feed> call() => _repository.getFeed();
}
