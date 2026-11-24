import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_appointment_app/domain/entities/feed.dart';
import 'package:medical_appointment_app/domain/usecases/get_feed.dart';
import 'package:medical_appointment_app/presentation/cubit/error_message.dart';
import 'package:medical_appointment_app/presentation/cubit/feed/feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit(this._getFeed) : super(const FeedInitial());

  final GetFeed _getFeed;

  Feed? _feed;
  String _query = '';
  String _selectedServiceId = '';
  bool _favoritesOnly = false;
  DoctorSort _sort = DoctorSort.nameAscending;

  Future<void> loadFeed() async {
    emit(const FeedLoading());

    try {
      _feed = await _getFeed();
      _query = '';
      _selectedServiceId = '';
      _favoritesOnly = false;
      _sort = DoctorSort.nameAscending;
      _emitContent();
    } catch (error) {
      emit(FeedError(errorMessage(error)));
    }
  }

  void searchDoctors(String value) {
    _query = value.trim();
    _emitContent();
  }

  void selectService(String serviceId) {
    _selectedServiceId = _selectedServiceId == serviceId ? '' : serviceId;
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
    _selectedServiceId = '';
    _favoritesOnly = false;
    _sort = DoctorSort.nameAscending;
    _emitContent();
  }

  void toggleFavorite(String doctorId) {
    final feed = _feed;
    if (feed == null) return;

    final doctors = feed.nearbyDoctors
        .map(
          (doctor) => doctor.id == doctorId
              ? doctor.copyWith(isFavorite: !doctor.isFavorite)
              : doctor,
        )
        .toList(growable: false);
    _feed = feed.copyWith(nearbyDoctors: doctors);
    _emitContent();
  }

  void _emitContent() {
    final feed = _feed;
    if (feed == null) return;

    final query = _query.toLowerCase();
    final doctors =
        feed.nearbyDoctors
            .where((doctor) {
              final matchesQuery =
                  query.isEmpty ||
                  doctor.name.toLowerCase().contains(query) ||
                  doctor.specialty.toLowerCase().contains(query) ||
                  doctor.distance.toLowerCase().contains(query);
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

    if (doctors.isEmpty) {
      emit(
        FeedEmpty(
          feed: feed,
          visibleDoctors: doctors,
          query: _query,
          selectedServiceId: _selectedServiceId,
          favoritesOnly: _favoritesOnly,
          sort: _sort,
        ),
      );
    } else {
      emit(
        FeedSuccess(
          feed: feed,
          visibleDoctors: doctors,
          query: _query,
          selectedServiceId: _selectedServiceId,
          favoritesOnly: _favoritesOnly,
          sort: _sort,
        ),
      );
    }
  }
}
