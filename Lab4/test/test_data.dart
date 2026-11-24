import 'package:medical_appointment_app/domain/entities/appointment_details.dart';
import 'package:medical_appointment_app/domain/entities/feed.dart';
import 'package:medical_appointment_app/domain/repositories/medical_repository.dart';

Feed sampleFeed() {
  return const Feed(
    user: UserProfile(
      name: 'Jonathan',
      greeting: 'Hi, Jonathan',
      subtitle: 'May you always be healthy!',
      avatarUrl: 'https://example.com/user.jpg',
    ),
    hasUnreadNotification: true,
    searchHint: 'Search something',
    appointment: HomeAppointment(
      title: 'Appointment',
      date: '22 October, 2023',
      time: '08:00 AM - 10.30 AM',
      doctor: HomeAppointmentDoctor(
        name: 'Dr. Richar Kandowen',
        specialty: 'Child Specialist',
        avatarUrl: 'https://example.com/appointment.jpg',
      ),
    ),
    healthServices: [
      HealthService(
        id: 'tooth',
        name: 'Tooth',
        iconUrl: 'https://example.com/tooth.svg',
      ),
      HealthService(
        id: 'eye',
        name: 'Eye',
        iconUrl: 'https://example.com/eye.svg',
      ),
    ],
    nearbyDoctors: [
      Doctor(
        id: 'doctor-001',
        name: 'Dr. Emmly Lestiryno',
        specialty: 'General Practitioner',
        serviceIds: ['tooth', 'eye'],
        distance: '500M from you',
        avatarUrl: 'https://example.com/doctor1.jpg',
        isFavorite: false,
      ),
      Doctor(
        id: 'doctor-002',
        name: 'Dr. Sonja Litel',
        specialty: 'Dental Specialist',
        serviceIds: ['tooth'],
        distance: '753M from you',
        avatarUrl: 'https://example.com/doctor2.jpg',
        isFavorite: false,
      ),
    ],
  );
}

AppointmentDetails sampleDetails() {
  return const AppointmentDetails(
    title: 'Appointment',
    doctor: AppointmentDoctor(
      name: 'Dr.Upul',
      clinic: 'Denteeth',
      avatarUrl: 'https://example.com/details.jpg',
      canMessage: true,
      canCall: true,
      canVideoCall: true,
    ),
    payment: PaymentInfo(
      label: 'Payment',
      amount: 120,
      currency: 'USD',
      formatted: r'$120.00',
    ),
    details: DetailsInfo(title: 'Details', description: 'Description'),
    workingHours: OptionGroup(
      title: 'Working Hours',
      showAll: true,
      slots: [
        ChoiceSlot(id: '10am', label: '10.00 AM', selected: false),
        ChoiceSlot(id: '11am', label: '11.00 AM', selected: true),
      ],
    ),
    dates: OptionGroup(
      title: 'Date',
      showAll: true,
      slots: [
        ChoiceSlot(id: 'sun-4', label: 'Sun 4', selected: true),
        ChoiceSlot(id: 'mon-5', label: 'Mon 5', selected: false),
      ],
    ),
    bookingAction: BookingAction(label: 'Book an Appointment', enabled: true),
  );
}

class FakeMedicalRepository implements MedicalRepository {
  FakeMedicalRepository({this.failFeed = false, this.failDetails = false});

  final bool failFeed;
  final bool failDetails;

  @override
  Future<Feed> getFeed() async {
    if (failFeed) throw StateError('Feed error');
    return sampleFeed();
  }

  @override
  Future<AppointmentDetails> getAppointmentDetails() async {
    if (failDetails) throw StateError('Details error');
    return sampleDetails();
  }
}

Map<String, dynamic> feedJson() {
  return {
    'user': {
      'name': 'Jonathan',
      'greeting': 'Hi, Jonathan',
      'subtitle': 'May you always be healthy!',
      'avatarUrl': 'https://example.com/user.jpg',
    },
    'notifications': {'hasUnread': true},
    'search': {'hint': 'Search something'},
    'appointment': {
      'title': 'Appointment',
      'date': '22 October, 2023',
      'time': '08:00 AM - 10.30 AM',
      'doctor': {
        'name': 'Dr. Richar Kandowen',
        'specialty': 'Child Specialist',
        'avatarUrl': 'https://example.com/appointment.jpg',
      },
    },
    'healthServices': [
      {
        'id': 'tooth',
        'name': 'Tooth',
        'iconUrl': 'https://example.com/tooth.svg',
      },
      {'id': 'eye', 'name': 'Eye', 'iconUrl': 'https://example.com/eye.svg'},
    ],
    'nearbyDoctors': [
      {
        'id': 'doctor-001',
        'name': 'Dr. Emmly Lestiryno',
        'specialty': 'General Practitioner',
        'distance': '500M from you',
        'avatarUrl': 'https://example.com/doctor1.jpg',
        'isFavorite': false,
      },
      {
        'id': 'doctor-002',
        'name': 'Dr. Sonja Litel',
        'specialty': 'Dental Specialist',
        'distance': '753M from you',
        'avatarUrl': 'https://example.com/doctor2.jpg',
        'isFavorite': false,
      },
    ],
  };
}

Map<String, dynamic> detailsJson() {
  return {
    'title': 'Appointment',
    'doctor': {
      'name': 'Dr.Upul',
      'clinic': 'Denteeth',
      'avatarUrl': 'https://example.com/details.jpg',
      'actions': {'message': true, 'call': true, 'videoCall': true},
    },
    'payment': {
      'label': 'Payment',
      'amount': 120.0,
      'currency': 'USD',
      'formatted': r'$120.00',
    },
    'details': {'title': 'Details', 'description': 'Description'},
    'workingHours': {
      'title': 'Working Hours',
      'showAll': true,
      'slots': [
        {'id': '10am', 'label': '10.00 AM', 'selected': false},
        {'id': '11am', 'label': '11.00 AM', 'selected': true},
      ],
    },
    'date': {
      'title': 'Date',
      'showAll': true,
      'slots': [
        {'id': 'sun-4', 'label': 'Sun 4', 'selected': true},
        {'id': 'mon-5', 'label': 'Mon 5', 'selected': false},
      ],
    },
    'actions': {
      'bookAppointment': {'label': 'Book an Appointment', 'enabled': true},
    },
  };
}
