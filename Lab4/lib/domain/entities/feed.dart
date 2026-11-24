class Feed {
  const Feed({
    required this.user,
    required this.hasUnreadNotification,
    required this.searchHint,
    required this.appointment,
    required this.healthServices,
    required this.nearbyDoctors,
  });

  final UserProfile user;
  final bool hasUnreadNotification;
  final String searchHint;
  final HomeAppointment appointment;
  final List<HealthService> healthServices;
  final List<Doctor> nearbyDoctors;

  Feed copyWith({List<Doctor>? nearbyDoctors}) {
    return Feed(
      user: user,
      hasUnreadNotification: hasUnreadNotification,
      searchHint: searchHint,
      appointment: appointment,
      healthServices: healthServices,
      nearbyDoctors: nearbyDoctors ?? this.nearbyDoctors,
    );
  }
}

class UserProfile {
  const UserProfile({
    required this.name,
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
  });

  final String name;
  final String greeting;
  final String subtitle;
  final String avatarUrl;
}

class HomeAppointment {
  const HomeAppointment({
    required this.title,
    required this.date,
    required this.time,
    required this.doctor,
  });

  final String title;
  final String date;
  final String time;
  final HomeAppointmentDoctor doctor;
}

class HomeAppointmentDoctor {
  const HomeAppointmentDoctor({
    required this.name,
    required this.specialty,
    required this.avatarUrl,
  });

  final String name;
  final String specialty;
  final String avatarUrl;
}

class HealthService {
  const HealthService({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  final String id;
  final String name;
  final String iconUrl;
}

class Doctor {
  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.serviceIds,
    required this.distance,
    required this.avatarUrl,
    required this.isFavorite,
  });

  final String id;
  final String name;
  final String specialty;
  final List<String> serviceIds;
  final String distance;
  final String avatarUrl;
  final bool isFavorite;

  Doctor copyWith({bool? isFavorite}) {
    return Doctor(
      id: id,
      name: name,
      specialty: specialty,
      serviceIds: serviceIds,
      distance: distance,
      avatarUrl: avatarUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
