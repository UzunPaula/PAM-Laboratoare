import 'package:flutter_test/flutter_test.dart';
import 'package:medical_appointment_app/data/models/medical_data.dart';
import 'package:medical_appointment_app/data/repositories/medical_repository.dart';
import 'package:medical_appointment_app/logic/medical_cubit/medical_cubit.dart';
import 'package:medical_appointment_app/logic/medical_cubit/medical_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads JSON asynchronously and emits Success', () async {
    final cubit = MedicalCubit(MedicalRepository());
    addTearDown(cubit.close);

    await cubit.loadData();

    expect(cubit.state, isA<MedicalSuccess>());
    final state = cubit.state as MedicalSuccess;
    expect(state.visibleDoctors, hasLength(2));
  });

  test('search can emit Empty and can be cleared', () async {
    final cubit = MedicalCubit(MedicalRepository());
    addTearDown(cubit.close);
    await cubit.loadData();

    cubit.searchDoctors('doctor who does not exist');
    expect(cubit.state, isA<MedicalEmpty>());

    cubit.clearFilters();
    expect(cubit.state, isA<MedicalSuccess>());
  });

  test('filters by service and favorites and sorts doctors', () async {
    final cubit = MedicalCubit(MedicalRepository());
    addTearDown(cubit.close);
    await cubit.loadData();

    cubit.selectService('eye');
    var state = cubit.state as MedicalSuccess;
    expect(state.visibleDoctors.map((doctor) => doctor.id), ['doctor-001']);

    cubit.selectService('tooth');
    cubit.setSort(DoctorSort.nameDescending);
    state = cubit.state as MedicalSuccess;
    expect(state.visibleDoctors.first.id, 'doctor-002');

    cubit.toggleFavorite('doctor-002');
    cubit.setFavoritesOnly(true);
    state = cubit.state as MedicalSuccess;
    expect(state.visibleDoctors.map((doctor) => doctor.id), ['doctor-002']);
  });

  test('emits Error when the repository cannot load data', () async {
    final cubit = MedicalCubit(_FailingRepository());
    addTearDown(cubit.close);

    await cubit.loadData();

    expect(cubit.state, isA<MedicalError>());
  });
}

class _FailingRepository extends MedicalRepository {
  @override
  Future<MedicalData> loadMedicalData() async {
    throw StateError('Test error');
  }
}
