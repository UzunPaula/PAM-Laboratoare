import 'package:medical_appointment_app/domain/entities/appointment_details.dart';

sealed class AppointmentState {
  const AppointmentState();
}

class AppointmentInitial extends AppointmentState {
  const AppointmentInitial();
}

class AppointmentLoading extends AppointmentState {
  const AppointmentLoading();
}

class AppointmentSuccess extends AppointmentState {
  const AppointmentSuccess({
    required this.details,
    required this.selectedTimeId,
    required this.selectedDateId,
  });

  final AppointmentDetails details;
  final String selectedTimeId;
  final String selectedDateId;

  AppointmentSuccess copyWith({
    String? selectedTimeId,
    String? selectedDateId,
  }) {
    return AppointmentSuccess(
      details: details,
      selectedTimeId: selectedTimeId ?? this.selectedTimeId,
      selectedDateId: selectedDateId ?? this.selectedDateId,
    );
  }
}

class AppointmentError extends AppointmentState {
  const AppointmentError(this.message);

  final String message;
}
