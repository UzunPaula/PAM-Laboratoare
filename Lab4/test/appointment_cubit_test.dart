import 'package:flutter_test/flutter_test.dart';
import 'package:medical_appointment_app/domain/usecases/get_appointment_details.dart';
import 'package:medical_appointment_app/presentation/cubit/appointment/appointment_cubit.dart';
import 'package:medical_appointment_app/presentation/cubit/appointment/appointment_state.dart';

import 'test_data.dart';

void main() {
  test('loads details and keeps API default selections', () async {
    final cubit = AppointmentCubit(
      GetAppointmentDetails(FakeMedicalRepository()),
    );
    addTearDown(cubit.close);

    await cubit.loadDetails();

    final state = cubit.state as AppointmentSuccess;
    expect(state.details.doctor.name, 'Dr.Upul');
    expect(state.selectedTimeId, '11am');
    expect(state.selectedDateId, 'sun-4');
  });

  test('changes date and time selections', () async {
    final cubit = AppointmentCubit(
      GetAppointmentDetails(FakeMedicalRepository()),
    );
    addTearDown(cubit.close);
    await cubit.loadDetails();

    cubit.selectTime('10am');
    cubit.selectDate('mon-5');

    final state = cubit.state as AppointmentSuccess;
    expect(state.selectedTimeId, '10am');
    expect(state.selectedDateId, 'mon-5');
  });

  test('emits Error when details request fails', () async {
    final cubit = AppointmentCubit(
      GetAppointmentDetails(FakeMedicalRepository(failDetails: true)),
    );
    addTearDown(cubit.close);

    await cubit.loadDetails();

    expect(cubit.state, isA<AppointmentError>());
  });
}
