import 'package:medical_appointment_app/data/models/json_helpers.dart';
import 'package:medical_appointment_app/domain/entities/appointment_details.dart';

class AppointmentDetailsModel extends AppointmentDetails {
  const AppointmentDetailsModel({
    required super.title,
    required super.doctor,
    required super.payment,
    required super.details,
    required super.workingHours,
    required super.dates,
    required super.bookingAction,
  });

  factory AppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    final doctorJson = readMap(json, 'doctor');
    final doctorActions = readMap(doctorJson, 'actions');
    final paymentJson = readMap(json, 'payment');
    final detailsJson = readMap(json, 'details');

    return AppointmentDetailsModel(
      title: readString(json, 'title'),
      doctor: AppointmentDoctor(
        name: readString(doctorJson, 'name'),
        clinic: readString(doctorJson, 'clinic'),
        avatarUrl: readString(doctorJson, 'avatarUrl'),
        canMessage: doctorActions['message'] as bool? ?? false,
        canCall: doctorActions['call'] as bool? ?? false,
        canVideoCall: doctorActions['videoCall'] as bool? ?? false,
      ),
      payment: PaymentInfo(
        label: readString(paymentJson, 'label'),
        amount: (paymentJson['amount'] as num?)?.toDouble() ?? 0,
        currency: readString(paymentJson, 'currency'),
        formatted: readString(paymentJson, 'formatted'),
      ),
      details: DetailsInfo(
        title: readString(detailsJson, 'title'),
        description: readString(detailsJson, 'description'),
      ),
      workingHours: _optionGroupFromJson(readMap(json, 'workingHours')),
      dates: _optionGroupFromJson(readMap(json, 'date')),
      bookingAction: _bookingActionFromJson(
        readMap(readMap(json, 'actions'), 'bookAppointment'),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'doctor': {
        'name': doctor.name,
        'clinic': doctor.clinic,
        'avatarUrl': doctor.avatarUrl,
        'actions': {
          'message': doctor.canMessage,
          'call': doctor.canCall,
          'videoCall': doctor.canVideoCall,
        },
      },
      'payment': {
        'label': payment.label,
        'amount': payment.amount,
        'currency': payment.currency,
        'formatted': payment.formatted,
      },
      'details': {'title': details.title, 'description': details.description},
      'workingHours': _optionGroupToJson(workingHours),
      'date': _optionGroupToJson(dates),
      'actions': {
        'bookAppointment': {
          'label': bookingAction.label,
          'enabled': bookingAction.enabled,
        },
      },
    };
  }
}

OptionGroup _optionGroupFromJson(Map<String, dynamic> json) {
  return OptionGroup(
    title: readString(json, 'title'),
    showAll: json['showAll'] as bool? ?? false,
    slots: readList(json, 'slots')
        .map((item) {
          final slot = asMap(item);
          return ChoiceSlot(
            id: readString(slot, 'id'),
            label: readString(slot, 'label'),
            selected: slot['selected'] as bool? ?? false,
          );
        })
        .toList(growable: false),
  );
}

BookingAction _bookingActionFromJson(Map<String, dynamic> json) {
  return BookingAction(
    label: readString(json, 'label'),
    enabled: json['enabled'] as bool? ?? false,
  );
}

Map<String, dynamic> _optionGroupToJson(OptionGroup group) {
  return {
    'title': group.title,
    'showAll': group.showAll,
    'slots': group.slots
        .map(
          (slot) => {
            'id': slot.id,
            'label': slot.label,
            'selected': slot.selected,
          },
        )
        .toList(),
  };
}
