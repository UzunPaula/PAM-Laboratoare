import 'package:flutter_test/flutter_test.dart';
import 'package:medical_appointment_app/domain/usecases/get_feed.dart';
import 'package:medical_appointment_app/presentation/cubit/feed/feed_cubit.dart';
import 'package:medical_appointment_app/presentation/cubit/feed/feed_state.dart';

import 'test_data.dart';

void main() {
  test('loads feed asynchronously and emits Success', () async {
    final cubit = FeedCubit(GetFeed(FakeMedicalRepository()));
    addTearDown(cubit.close);

    await cubit.loadFeed();

    expect(cubit.state, isA<FeedSuccess>());
    expect((cubit.state as FeedSuccess).visibleDoctors, hasLength(2));
  });

  test('search emits Empty and clearFilters restores Success', () async {
    final cubit = FeedCubit(GetFeed(FakeMedicalRepository()));
    addTearDown(cubit.close);
    await cubit.loadFeed();

    cubit.searchDoctors('missing doctor');
    expect(cubit.state, isA<FeedEmpty>());

    cubit.clearFilters();
    expect(cubit.state, isA<FeedSuccess>());
  });

  test('filters, sorts and toggles favorites', () async {
    final cubit = FeedCubit(GetFeed(FakeMedicalRepository()));
    addTearDown(cubit.close);
    await cubit.loadFeed();

    cubit.selectService('eye');
    var state = cubit.state as FeedSuccess;
    expect(state.visibleDoctors.single.id, 'doctor-001');

    cubit.selectService('eye');
    cubit.setSort(DoctorSort.nameDescending);
    state = cubit.state as FeedSuccess;
    expect(state.visibleDoctors.first.id, 'doctor-002');

    cubit.toggleFavorite('doctor-002');
    cubit.setFavoritesOnly(true);
    state = cubit.state as FeedSuccess;
    expect(state.visibleDoctors.single.id, 'doctor-002');
  });

  test('emits Error when repository fails', () async {
    final cubit = FeedCubit(GetFeed(FakeMedicalRepository(failFeed: true)));
    addTearDown(cubit.close);

    await cubit.loadFeed();

    expect(cubit.state, isA<FeedError>());
  });
}
