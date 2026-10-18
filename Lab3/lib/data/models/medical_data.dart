class MedicalData {
  const MedicalData({required this.home, required this.appointmentDetails});

  final HomeData home;
  final AppointmentDetails appointmentDetails;

  factory MedicalData.fromJson(Map<String, dynamic> json) {
    return MedicalData(
      home: HomeData.fromJson(_map(json, 'homeScreen')),
      appointmentDetails: AppointmentDetails.fromJson(
        _map(json, 'appointmentDetails'),
      ),
    );
  }

  MedicalData copyWith({HomeData? home}) {
    return MedicalData(
      home: home ?? this.home,
      appointmentDetails: appointmentDetails,
    );
  }
}

class HomeData {
  const HomeData({
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

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      user: UserProfile.fromJson(_map(json, 'user')),
      hasUnreadNotification:
          _map(json, 'notifications')['hasUnread'] as bool? ?? false,
      searchHint: _map(json, 'search')['hint'] as String? ?? 'Search',
      appointment: HomeAppointment.fromJson(_map(json, 'appointment')),
      healthServices: _list(json, 'healthServices')
          .map((item) => HealthService.fromJson(_asMap(item)))
          .toList(growable: false),
      nearbyDoctors: _list(
        json,
        'nearbyDoctors',
      ).map((item) => Doctor.fromJson(_asMap(item))).toList(growable: false),
    );
  }

  HomeData copyWith({List<Doctor>? nearbyDoctors}) {
    return HomeData(
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

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: _string(json, 'name'),
      greeting: _string(json, 'greeting'),
      subtitle: _string(json, 'subtitle'),
      avatarUrl: _string(json, 'avatarUrl'),
    );
  }
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

  factory HomeAppointment.fromJson(Map<String, dynamic> json) {
    return HomeAppointment(
      title: _string(json, 'title'),
      date: _string(json, 'date'),
      time: _string(json, 'time'),
      doctor: HomeAppointmentDoctor.fromJson(_map(json, 'doctor')),
    );
  }
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

  factory HomeAppointmentDoctor.fromJson(Map<String, dynamic> json) {
    return HomeAppointmentDoctor(
      name: _string(json, 'name'),
      specialty: _string(json, 'specialty'),
      avatarUrl: _string(json, 'avatarUrl'),
    );
  }
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

  factory HealthService.fromJson(Map<String, dynamic> json) {
    return HealthService(
      id: _string(json, 'id'),
      name: _string(json, 'name'),
      iconUrl: _string(json, 'iconUrl'),
    );
  }
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

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: _string(json, 'id'),
      name: _string(json, 'name'),
      specialty: _string(json, 'specialty'),
      serviceIds: _list(json, 'serviceIds')
          .map(
            (item) => item is String
                ? item
                : throw const FormatException(
                    'Lista "serviceIds" contine o valoare invalida.',
                  ),
          )
          .toList(growable: false),
      distance: _string(json, 'distance'),
      avatarUrl: _string(json, 'avatarUrl'),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

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

class AppointmentDetails {
  const AppointmentDetails({
    required this.title,
    required this.doctor,
    required this.payment,
    required this.details,
    required this.workingHours,
    required this.dates,
    required this.bookingAction,
  });

  final String title;
  final AppointmentDoctor doctor;
  final PaymentInfo payment;
  final DetailsInfo details;
  final OptionGroup workingHours;
  final OptionGroup dates;
  final BookingAction bookingAction;

  factory AppointmentDetails.fromJson(Map<String, dynamic> json) {
    return AppointmentDetails(
      title: _string(json, 'title'),
      doctor: AppointmentDoctor.fromJson(_map(json, 'doctor')),
      payment: PaymentInfo.fromJson(_map(json, 'payment')),
      details: DetailsInfo.fromJson(_map(json, 'details')),
      workingHours: OptionGroup.fromJson(_map(json, 'workingHours')),
      dates: OptionGroup.fromJson(_map(json, 'date')),
      bookingAction: BookingAction.fromJson(
        _map(_map(json, 'actions'), 'bookAppointment'),
      ),
    );
  }
}

class AppointmentDoctor {
  const AppointmentDoctor({
    required this.name,
    required this.clinic,
    required this.avatarUrl,
    required this.canMessage,
    required this.canCall,
    required this.canVideoCall,
  });

  final String name;
  final String clinic;
  final String avatarUrl;
  final bool canMessage;
  final bool canCall;
  final bool canVideoCall;

  factory AppointmentDoctor.fromJson(Map<String, dynamic> json) {
    final actions = _map(json, 'actions');
    return AppointmentDoctor(
      name: _string(json, 'name'),
      clinic: _string(json, 'clinic'),
      avatarUrl: _string(json, 'avatarUrl'),
      canMessage: actions['message'] as bool? ?? false,
      canCall: actions['call'] as bool? ?? false,
      canVideoCall: actions['videoCall'] as bool? ?? false,
    );
  }
}

class PaymentInfo {
  const PaymentInfo({
    required this.label,
    required this.amount,
    required this.currency,
    required this.formatted,
  });

  final String label;
  final double amount;
  final String currency;
  final String formatted;

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      label: _string(json, 'label'),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      currency: _string(json, 'currency'),
      formatted: _string(json, 'formatted'),
    );
  }
}

class DetailsInfo {
  const DetailsInfo({required this.title, required this.description});

  final String title;
  final String description;

  factory DetailsInfo.fromJson(Map<String, dynamic> json) {
    return DetailsInfo(
      title: _string(json, 'title'),
      description: _string(json, 'description'),
    );
  }
}

class OptionGroup {
  const OptionGroup({
    required this.title,
    required this.showAll,
    required this.slots,
  });

  final String title;
  final bool showAll;
  final List<ChoiceSlot> slots;

  factory OptionGroup.fromJson(Map<String, dynamic> json) {
    return OptionGroup(
      title: _string(json, 'title'),
      showAll: json['showAll'] as bool? ?? false,
      slots: _list(json, 'slots')
          .map((item) => ChoiceSlot.fromJson(_asMap(item)))
          .toList(growable: false),
    );
  }
}

class ChoiceSlot {
  const ChoiceSlot({
    required this.id,
    required this.label,
    required this.selected,
  });

  final String id;
  final String label;
  final bool selected;

  factory ChoiceSlot.fromJson(Map<String, dynamic> json) {
    return ChoiceSlot(
      id: _string(json, 'id'),
      label: _string(json, 'label'),
      selected: json['selected'] as bool? ?? false,
    );
  }
}

class BookingAction {
  const BookingAction({required this.label, required this.enabled});

  final String label;
  final bool enabled;

  factory BookingAction.fromJson(Map<String, dynamic> json) {
    return BookingAction(
      label: _string(json, 'label'),
      enabled: json['enabled'] as bool? ?? false,
    );
  }
}

Map<String, dynamic> _map(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! Map) {
    throw FormatException('Campul "$key" lipseste sau nu este un obiect.');
  }
  return Map<String, dynamic>.from(value);
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is! Map) {
    throw const FormatException('Element JSON invalid.');
  }
  return Map<String, dynamic>.from(value);
}

List<dynamic> _list(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List) {
    throw FormatException('Campul "$key" lipseste sau nu este o lista.');
  }
  return value;
}

String _string(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String) {
    throw FormatException('Campul "$key" lipseste sau nu este text.');
  }
  return value;
}
