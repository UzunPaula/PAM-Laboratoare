import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_appointment_app/core/app_colors.dart';
import 'package:medical_appointment_app/data/models/medical_data.dart';
import 'package:medical_appointment_app/logic/medical_cubit/medical_cubit.dart';
import 'package:medical_appointment_app/logic/medical_cubit/medical_state.dart';
import 'package:medical_appointment_app/presentation/widgets/appointment_widgets.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key, this.doctor});

  final Doctor? doctor;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<MedicalCubit, MedicalState>(
            builder: (context, state) {
              if (state is! MedicalContentState) {
                return const Center(child: CircularProgressIndicator());
              }
              return _AppointmentContent(state: state, selectedDoctor: doctor);
            },
          ),
        ),
      ),
    );
  }
}

class _AppointmentContent extends StatelessWidget {
  const _AppointmentContent({required this.state, this.selectedDoctor});

  final MedicalContentState state;
  final Doctor? selectedDoctor;

  @override
  Widget build(BuildContext context) {
    final details = state.data.appointmentDetails;
    final doctor = _displayedDoctor(details.doctor);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: SizedBox(
            width: constraints.maxWidth > 480 ? 430 : constraints.maxWidth,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(26, 18, 26, 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 46,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppointmentHeader(
                      title: details.title,
                      onBack: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: 32),
                    DoctorSummary(
                      doctor: doctor,
                      payment: details.payment,
                      imageAsset: _doctorImageAsset(),
                    ),
                    const SizedBox(height: 38),
                    Text(
                      details.details.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      details.details.description,
                      style: const TextStyle(
                        color: Color(0xFF858585),
                        fontSize: 13,
                        height: 1.32,
                      ),
                    ),
                    const SizedBox(height: 42),
                    ChoiceSection(
                      group: details.workingHours,
                      selectedId: state.selectedTimeId,
                      onSelected: context.read<MedicalCubit>().selectTime,
                    ),
                    const SizedBox(height: 44),
                    ChoiceSection(
                      group: details.dates,
                      selectedId: state.selectedDateId,
                      onSelected: context.read<MedicalCubit>().selectDate,
                    ),
                    const SizedBox(height: 78),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: FilledButton(
                        onPressed: details.bookingAction.enabled
                            ? () => _bookAppointment(
                                context,
                                details,
                                doctor.name,
                              )
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.deepTeal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          details.bookingAction.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  AppointmentDoctor _displayedDoctor(AppointmentDoctor fallback) {
    final doctor = selectedDoctor;
    if (doctor == null) return fallback;

    return AppointmentDoctor(
      name: doctor.name,
      clinic: doctor.specialty,
      avatarUrl: doctor.avatarUrl,
      canMessage: fallback.canMessage,
      canCall: fallback.canCall,
      canVideoCall: fallback.canVideoCall,
    );
  }

  String _doctorImageAsset() {
    return switch (selectedDoctor?.id) {
      'doctor-001' => 'assets/images/doctor_nearby_1.png',
      'doctor-002' => 'assets/images/doctor_nearby_2.png',
      _ => 'assets/images/appointment_doctor.png',
    };
  }

  void _bookAppointment(
    BuildContext context,
    AppointmentDetails details,
    String doctorName,
  ) {
    final selectedDate = _selectedLabel(details.dates, state.selectedDateId);
    final selectedTime = _selectedLabel(
      details.workingHours,
      state.selectedTimeId,
    );

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle_rounded,
            color: AppColors.deepTeal,
            size: 48,
          ),
          title: const Text('Appointment booked'),
          content: Text(
            'Your appointment with $doctorName is scheduled for '
            '$selectedDate at $selectedTime.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.deepTeal,
              ),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  String _selectedLabel(OptionGroup group, String id) {
    if (group.slots.isEmpty) return '-';
    return group.slots
        .firstWhere((slot) => slot.id == id, orElse: () => group.slots.first)
        .label;
  }
}
