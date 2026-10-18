import 'package:medical_appointment_app/data/models/medical_data.dart';

enum DoctorSort { nameAscending, nameDescending }

sealed class MedicalState {
  const MedicalState();
}

class MedicalInitial extends MedicalState {
  const MedicalInitial();
}

class MedicalLoading extends MedicalState {
  const MedicalLoading();
}

sealed class MedicalContentState extends MedicalState {
  const MedicalContentState({
    required this.data,
    required this.visibleDoctors,
    required this.query,
    required this.selectedServiceId,
    required this.favoritesOnly,
    required this.sort,
    required this.selectedTimeId,
    required this.selectedDateId,
  });

  final MedicalData data;
  final List<Doctor> visibleDoctors;
  final String query;
  final String selectedServiceId;
  final bool favoritesOnly;
  final DoctorSort sort;
  final String selectedTimeId;
  final String selectedDateId;
}

class MedicalSuccess extends MedicalContentState {
  const MedicalSuccess({
    required super.data,
    required super.visibleDoctors,
    required super.query,
    required super.selectedServiceId,
    required super.favoritesOnly,
    required super.sort,
    required super.selectedTimeId,
    required super.selectedDateId,
  });
}

class MedicalEmpty extends MedicalContentState {
  const MedicalEmpty({
    required super.data,
    required super.visibleDoctors,
    required super.query,
    required super.selectedServiceId,
    required super.favoritesOnly,
    required super.sort,
    required super.selectedTimeId,
    required super.selectedDateId,
  });
}

class MedicalError extends MedicalState {
  const MedicalError(this.message);

  final String message;
}
