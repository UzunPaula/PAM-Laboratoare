import 'package:medical_appointment_app/data/models/json_helpers.dart';
import 'package:medical_appointment_app/domain/entities/feed.dart';

class FeedModel extends Feed {
  const FeedModel({
    required super.user,
    required super.hasUnreadNotification,
    required super.searchHint,
    required super.appointment,
    required super.healthServices,
    required super.nearbyDoctors,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    final services = readList(json, 'healthServices')
        .map((item) => _healthServiceFromJson(asMap(item)))
        .toList(growable: false);
    final allServiceIds = services.map((service) => service.id).toList();

    return FeedModel(
      user: _userFromJson(readMap(json, 'user')),
      hasUnreadNotification:
          readMap(json, 'notifications')['hasUnread'] as bool? ?? false,
      searchHint: readString(readMap(json, 'search'), 'hint'),
      appointment: _appointmentFromJson(readMap(json, 'appointment')),
      healthServices: services,
      nearbyDoctors: readList(json, 'nearbyDoctors')
          .map((item) => _doctorFromJson(asMap(item), allServiceIds))
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {
        'name': user.name,
        'greeting': user.greeting,
        'subtitle': user.subtitle,
        'avatarUrl': user.avatarUrl,
      },
      'notifications': {'hasUnread': hasUnreadNotification},
      'search': {'hint': searchHint},
      'appointment': {
        'title': appointment.title,
        'date': appointment.date,
        'time': appointment.time,
        'doctor': {
          'name': appointment.doctor.name,
          'specialty': appointment.doctor.specialty,
          'avatarUrl': appointment.doctor.avatarUrl,
        },
      },
      'healthServices': healthServices
          .map(
            (service) => {
              'id': service.id,
              'name': service.name,
              'iconUrl': service.iconUrl,
            },
          )
          .toList(),
      'nearbyDoctors': nearbyDoctors
          .map(
            (doctor) => {
              'id': doctor.id,
              'name': doctor.name,
              'specialty': doctor.specialty,
              'distance': doctor.distance,
              'avatarUrl': doctor.avatarUrl,
              'isFavorite': doctor.isFavorite,
            },
          )
          .toList(),
    };
  }
}

UserProfile _userFromJson(Map<String, dynamic> json) {
  return UserProfile(
    name: readString(json, 'name'),
    greeting: readString(json, 'greeting'),
    subtitle: readString(json, 'subtitle'),
    avatarUrl: readString(json, 'avatarUrl'),
  );
}

HomeAppointment _appointmentFromJson(Map<String, dynamic> json) {
  final doctorJson = readMap(json, 'doctor');
  return HomeAppointment(
    title: readString(json, 'title'),
    date: readString(json, 'date'),
    time: readString(json, 'time'),
    doctor: HomeAppointmentDoctor(
      name: readString(doctorJson, 'name'),
      specialty: readString(doctorJson, 'specialty'),
      avatarUrl: readString(doctorJson, 'avatarUrl'),
    ),
  );
}

HealthService _healthServiceFromJson(Map<String, dynamic> json) {
  return HealthService(
    id: readString(json, 'id'),
    name: readString(json, 'name'),
    iconUrl: readString(json, 'iconUrl'),
  );
}

Doctor _doctorFromJson(Map<String, dynamic> json, List<String> allServiceIds) {
  final specialty = readString(json, 'specialty');
  final serviceIds = specialty.toLowerCase().contains('dental')
      ? const ['tooth']
      : List<String>.unmodifiable(allServiceIds);

  return Doctor(
    id: readString(json, 'id'),
    name: readString(json, 'name'),
    specialty: specialty,
    serviceIds: serviceIds,
    distance: readString(json, 'distance'),
    avatarUrl: readString(json, 'avatarUrl'),
    isFavorite: json['isFavorite'] as bool? ?? false,
  );
}
