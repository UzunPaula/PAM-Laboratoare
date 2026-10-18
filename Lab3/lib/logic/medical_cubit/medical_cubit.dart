import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_appointment_app/data/models/medical_data.dart';
import 'package:medical_appointment_app/data/repositories/medical_repository.dart';
import 'package:medical_appointment_app/logic/medical_cubit/medical_state.dart';

class MedicalCubit extends Cubit<MedicalState> {
  MedicalCubit(this._repository) : super(const MedicalInitial());

  final MedicalRepository _repository;

  MedicalData? _data;
  String _query = '';
  String _selectedServiceId = '';
  bool _favoritesOnly = false;
  DoctorSort _sort = DoctorSort.nameAscending;
  String _selectedTimeId = '';
  String _selectedDateId = '';

  Future<void> loadData() async {
    emit(const MedicalLoading());

    try {
      await Future<void>.delayed(const Duration(seconds: 2));
      final data = await _repository.loadMedicalData();
      _data = data;
      _selectedServiceId = data.home.healthServices.isEmpty
          ? ''
          : data.home.healthServices.first.id;
      _selectedTimeId = _initialSelection(data.appointmentDetails.workingHours);
      _selectedDateId = _initialSelection(data.appointmentDetails.dates);
      _emitContent();
    } on FormatException catch (error) {
      emit(MedicalError('Date JSON invalide: ${error.message}'));
    } catch (_) {
      emit(
        const MedicalError(
          'Datele nu au putut fi incarcate. Verifica fisierul JSON.',
        ),
      );
    }
  }

  void searchDoctors(String value) {
    _query = value.trim();
    _emitContent();
  }

  void selectService(String serviceId) {
    _selectedServiceId = serviceId;
    _emitContent();
  }

  void setFavoritesOnly(bool value) {
    _favoritesOnly = value;
    _emitContent();
  }

  void setSort(DoctorSort value) {
    _sort = value;
    _emitContent();
  }

  void clearFilters() {
    _query = '';
    _favoritesOnly = false;
    _sort = DoctorSort.nameAscending;
    _emitContent();
  }

  void toggleFavorite(String doctorId) {
    final data = _data;
    if (data == null) return;

    final updatedDoctors = data.home.nearbyDoctors
        .map(
          (doctor) => doctor.id == doctorId
              ? doctor.copyWith(isFavorite: !doctor.isFavorite)
              : doctor,
        )
        .toList(growable: false);

    _data = data.copyWith(
      home: data.home.copyWith(nearbyDoctors: updatedDoctors),
    );
    _emitContent();
  }

  void selectTime(String slotId) {
    _selectedTimeId = slotId;
    _emitContent();
  }

  void selectDate(String slotId) {
    _selectedDateId = slotId;
    _emitContent();
  }

  void _emitContent() {
    final data = _data;
    if (data == null) return;

    final normalizedQuery = _query.toLowerCase();
    final visibleDoctors =
        data.home.nearbyDoctors
            .where((doctor) {
              final matchesQuery =
                  normalizedQuery.isEmpty ||
                  doctor.name.toLowerCase().contains(normalizedQuery) ||
                  doctor.specialty.toLowerCase().contains(normalizedQuery) ||
                  doctor.distance.toLowerCase().contains(normalizedQuery);
              final matchesFavorite = !_favoritesOnly || doctor.isFavorite;
              final matchesService =
                  _selectedServiceId.isEmpty ||
                  doctor.serviceIds.contains(_selectedServiceId);
              return matchesQuery && matchesFavorite && matchesService;
            })
            .toList(growable: false)
          ..sort((first, second) {
            final result = first.name.compareTo(second.name);
            return _sort == DoctorSort.nameAscending ? result : -result;
          });

    final state = visibleDoctors.isEmpty
        ? MedicalEmpty(
            data: data,
            visibleDoctors: visibleDoctors,
            query: _query,
            selectedServiceId: _selectedServiceId,
            favoritesOnly: _favoritesOnly,
            sort: _sort,
            selectedTimeId: _selectedTimeId,
            selectedDateId: _selectedDateId,
          )
        : MedicalSuccess(
            data: data,
            visibleDoctors: visibleDoctors,
            query: _query,
            selectedServiceId: _selectedServiceId,
            favoritesOnly: _favoritesOnly,
            sort: _sort,
            selectedTimeId: _selectedTimeId,
            selectedDateId: _selectedDateId,
          );

    emit(state);
  }

  String _initialSelection(OptionGroup group) {
    if (group.slots.isEmpty) return '';
    return group.slots
        .firstWhere((slot) => slot.selected, orElse: () => group.slots.first)
        .id;
  }
}
