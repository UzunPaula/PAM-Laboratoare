import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_appointment_app/core/app_colors.dart';
import 'package:medical_appointment_app/domain/entities/appointment_details.dart';
import 'package:medical_appointment_app/domain/entities/feed.dart';
import 'package:medical_appointment_app/domain/usecases/get_appointment_details.dart';
import 'package:medical_appointment_app/presentation/cubit/appointment/appointment_cubit.dart';
import 'package:medical_appointment_app/presentation/cubit/appointment/appointment_state.dart';
import 'package:medical_appointment_app/presentation/widgets/appointment_widgets.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key, this.doctor});

  final Doctor? doctor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AppointmentCubit(context.read<GetAppointmentDetails>())
            ..loadDetails(),
      child: Theme(
        data: Theme.of(context).copyWith(
          textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
        ),
        child: Scaffold(
          body: SafeArea(
            child: BlocBuilder<AppointmentCubit, AppointmentState>(
              builder: (context, state) {
                return switch (state) {
                  AppointmentInitial() ||
                  AppointmentLoading() => const _AppointmentLoadingView(),
                  AppointmentError(:final message) => _AppointmentErrorView(
                    message: message,
                    onRetry: context.read<AppointmentCubit>().loadDetails,
                  ),
                  AppointmentSuccess() => _AppointmentContent(
                    state: state,
                    selectedDoctor: doctor,
                  ),
                };
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _AppointmentContent extends StatelessWidget {
  const _AppointmentContent({required this.state, this.selectedDoctor});

  final AppointmentSuccess state;
  final Doctor? selectedDoctor;

  @override
  Widget build(BuildContext context) {
    final details = state.details;
    final displayedDoctor = _displayedDoctor(details.doctor);

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
                      doctor: displayedDoctor,
                      payment: details.payment,
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
                      onSelected: context.read<AppointmentCubit>().selectTime,
                    ),
                    const SizedBox(height: 44),
                    ChoiceSection(
                      group: details.dates,
                      selectedId: state.selectedDateId,
                      onSelected: context.read<AppointmentCubit>().selectDate,
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
                                displayedDoctor.name,
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

  AppointmentDoctor _displayedDoctor(AppointmentDoctor apiDoctor) {
    final doctor = selectedDoctor;
    if (doctor == null) return apiDoctor;

    return AppointmentDoctor(
      name: doctor.name,
      clinic: doctor.specialty,
      avatarUrl: doctor.avatarUrl,
      canMessage: apiDoctor.canMessage,
      canCall: apiDoctor.canCall,
      canVideoCall: apiDoctor.canVideoCall,
    );
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
          title: const Text('Appointment selected'),
          content: Text(
            'Your appointment with $doctorName is selected for '
            '$selectedDate at $selectedTime. The API is read-only, so this '
            'selection is stored only while the app is open.',
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

class _AppointmentLoadingView extends StatelessWidget {
  const _AppointmentLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.deepTeal),
          SizedBox(height: 16),
          Text('Loading appointment from API...'),
        ],
      ),
    );
  }
}

class _AppointmentErrorView extends StatelessWidget {
  const _AppointmentErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 54, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
