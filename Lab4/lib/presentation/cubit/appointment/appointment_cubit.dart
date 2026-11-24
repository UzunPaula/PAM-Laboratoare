import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_appointment_app/domain/entities/appointment_details.dart';
import 'package:medical_appointment_app/domain/usecases/get_appointment_details.dart';
import 'package:medical_appointment_app/presentation/cubit/appointment/appointment_state.dart';
import 'package:medical_appointment_app/presentation/cubit/error_message.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit(this._getAppointmentDetails)
    : super(const AppointmentInitial());

  final GetAppointmentDetails _getAppointmentDetails;

  Future<void> loadDetails() async {
    emit(const AppointmentLoading());
    try {
      final details = await _getAppointmentDetails();
      emit(
        AppointmentSuccess(
          details: details,
          selectedTimeId: _initialSelection(details.workingHours),
          selectedDateId: _initialSelection(details.dates),
        ),
      );
    } catch (error) {
      emit(AppointmentError(errorMessage(error)));
    }
  }

  void selectTime(String slotId) {
    final current = state;
    if (current is AppointmentSuccess) {
      emit(current.copyWith(selectedTimeId: slotId));
    }
  }

  void selectDate(String slotId) {
    final current = state;
    if (current is AppointmentSuccess) {
      emit(current.copyWith(selectedDateId: slotId));
    }
  }

  String _initialSelection(OptionGroup group) {
    if (group.slots.isEmpty) return '';
    return group.slots
        .firstWhere((slot) => slot.selected, orElse: () => group.slots.first)
        .id;
  }
}
