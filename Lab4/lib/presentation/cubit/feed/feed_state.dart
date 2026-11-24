import 'package:medical_appointment_app/domain/entities/feed.dart';

enum DoctorSort { nameAscending, nameDescending }

sealed class FeedState {
  const FeedState();
}

class FeedInitial extends FeedState {
  const FeedInitial();
}

class FeedLoading extends FeedState {
  const FeedLoading();
}

sealed class FeedContentState extends FeedState {
  const FeedContentState({
    required this.feed,
    required this.visibleDoctors,
    required this.query,
    required this.selectedServiceId,
    required this.favoritesOnly,
    required this.sort,
  });

  final Feed feed;
  final List<Doctor> visibleDoctors;
  final String query;
  final String selectedServiceId;
  final bool favoritesOnly;
  final DoctorSort sort;
}

class FeedSuccess extends FeedContentState {
  const FeedSuccess({
    required super.feed,
    required super.visibleDoctors,
    required super.query,
    required super.selectedServiceId,
    required super.favoritesOnly,
    required super.sort,
  });
}

class FeedEmpty extends FeedContentState {
  const FeedEmpty({
    required super.feed,
    required super.visibleDoctors,
    required super.query,
    required super.selectedServiceId,
    required super.favoritesOnly,
    required super.sort,
  });
}

class FeedError extends FeedState {
  const FeedError(this.message);

  final String message;
}
