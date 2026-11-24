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
}

class DetailsInfo {
  const DetailsInfo({required this.title, required this.description});

  final String title;
  final String description;
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
}

class BookingAction {
  const BookingAction({required this.label, required this.enabled});

  final String label;
  final bool enabled;
}
