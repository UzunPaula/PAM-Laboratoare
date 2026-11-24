import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:medical_appointment_app/core/app_colors.dart';
import 'package:medical_appointment_app/data/datasources/medical_remote_data_source.dart';
import 'package:medical_appointment_app/data/repositories/medical_repository_impl.dart';
import 'package:medical_appointment_app/domain/repositories/medical_repository.dart';
import 'package:medical_appointment_app/domain/usecases/get_appointment_details.dart';
import 'package:medical_appointment_app/domain/usecases/get_feed.dart';
import 'package:medical_appointment_app/presentation/cubit/feed/feed_cubit.dart';
import 'package:medical_appointment_app/presentation/screens/home_screen.dart';

class MedicalAppointmentApp extends StatelessWidget {
  const MedicalAppointmentApp({super.key, this.repository});

  final MedicalRepository? repository;

  @override
  Widget build(BuildContext context) {
    final injectedRepository = repository;
    if (injectedRepository != null) {
      return _ConfiguredApp(repository: injectedRepository);
    }

    return RepositoryProvider<http.Client>(
      create: (_) => http.Client(),
      dispose: (client) => client.close(),
      child: Builder(
        builder: (context) {
          final dataSource = HttpMedicalRemoteDataSource(
            context.read<http.Client>(),
          );
          return _ConfiguredApp(repository: MedicalRepositoryImpl(dataSource));
        },
      ),
    );
  }
}

class _ConfiguredApp extends StatelessWidget {
  const _ConfiguredApp({required this.repository});

  final MedicalRepository repository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MedicalRepository>.value(value: repository),
        RepositoryProvider<GetFeed>(
          create: (context) => GetFeed(context.read<MedicalRepository>()),
        ),
        RepositoryProvider<GetAppointmentDetails>(
          create: (context) =>
              GetAppointmentDetails(context.read<MedicalRepository>()),
        ),
      ],
      child: BlocProvider(
        create: (context) => FeedCubit(context.read<GetFeed>())..loadFeed(),
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
      ),
    );
  }
}
