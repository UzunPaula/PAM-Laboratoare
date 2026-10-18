import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_appointment_app/core/app_colors.dart';
import 'package:medical_appointment_app/data/repositories/medical_repository.dart';
import 'package:medical_appointment_app/logic/medical_cubit/medical_cubit.dart';
import 'package:medical_appointment_app/presentation/screens/home_screen.dart';

class MedicalAppointmentApp extends StatelessWidget {
  const MedicalAppointmentApp({super.key, this.repository});

  final MedicalRepository? repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          MedicalCubit(repository ?? MedicalRepository())..loadData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Medical Appointment',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.teal,
            primary: AppColors.teal,
            surface: Colors.white,
          ),
          textTheme: GoogleFonts.outfitTextTheme().apply(
            bodyColor: AppColors.ink,
            displayColor: AppColors.ink,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
