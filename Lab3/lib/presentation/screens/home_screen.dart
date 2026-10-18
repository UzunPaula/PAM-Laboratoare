import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_appointment_app/core/app_colors.dart';
import 'package:medical_appointment_app/logic/medical_cubit/medical_cubit.dart';
import 'package:medical_appointment_app/logic/medical_cubit/medical_state.dart';
import 'package:medical_appointment_app/presentation/screens/appointment_screen.dart';
import 'package:medical_appointment_app/presentation/widgets/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState(); // pastreaza starea
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<MedicalCubit, MedicalState>(
          builder: (context, state) {
            return switch (state) {
              MedicalInitial() || MedicalLoading() => const _LoadingView(),
              MedicalError(:final message) => _ErrorView(
                message: message,
                onRetry: context.read<MedicalCubit>().loadData,
              ),
              MedicalContentState() => _buildContent(context, state),
            };
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MedicalContentState state) {
    final home = state.data.home;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: SizedBox(
            width: constraints.maxWidth > 420 ? 375 : constraints.maxWidth,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 34),
              children: [
                GreetingHeader(
                  user: home.user,
                  hasUnread: home.hasUnreadNotification,
                ),
                const SizedBox(height: 24),
                DoctorSearchField(
                  controller: _searchController,
                  hint: home.searchHint,
                  onChanged: context.read<MedicalCubit>().searchDoctors,
                  onFilter: () => _showFilters(context),
                ),
                const SizedBox(height: 24),
                AppointmentCard(
                  data: home.appointment,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AppointmentScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                SectionTitle(
                  title: 'Health Services',
                  onTap: () => _message(context, 'All health services'),
                ),
                const SizedBox(height: 16),
                CategoryStrip(
                  services: home.healthServices,
                  selectedId: state.selectedServiceId,
                  onSelected: context.read<MedicalCubit>().selectService,
                ),
                const SizedBox(height: 24),
                SectionTitle(
                  title: state.favoritesOnly
                      ? 'Favorite Doctors'
                      : 'Nearby Doctor',
                  onTap: () => _message(context, 'All nearby doctors'),
                ),
                const SizedBox(height: 12),
                if (state is MedicalEmpty)
                  _EmptyDoctorsView(
                    onClear: () {
                      _searchController.clear();
                      context.read<MedicalCubit>().clearFilters();
                    },
                  )
                else
                  ...state.visibleDoctors.map(
                    (doctor) => Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: DoctorRow(
                        doctor: doctor,
                        onFavorite: () => context
                            .read<MedicalCubit>()
                            .toggleFavorite(doctor.id),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => AppointmentScreen(doctor: doctor),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return BlocBuilder<MedicalCubit, MedicalState>(
          builder: (context, state) {
            if (state is! MedicalContentState) {
              return const SizedBox.shrink();
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filter and sort',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Favorites only'),
                      value: state.favoritesOnly,
                      activeThumbColor: AppColors.deepTeal,
                      onChanged: context.read<MedicalCubit>().setFavoritesOnly,
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        state.sort == DoctorSort.nameAscending
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: AppColors.deepTeal,
                      ),
                      title: const Text('Name: A to Z'),
                      onTap: () => context.read<MedicalCubit>().setSort(
                        DoctorSort.nameAscending,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        state.sort == DoctorSort.nameDescending
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: AppColors.deepTeal,
                      ),
                      title: const Text('Name: Z to A'),
                      onTap: () => context.read<MedicalCubit>().setSort(
                        DoctorSort.nameDescending,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          _searchController.clear();
                          context.read<MedicalCubit>().clearFilters();
                          Navigator.of(sheetContext).pop();
                        },
                        child: const Text('Clear filters'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _message(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.deepTeal),
          SizedBox(height: 16),
          Text('Loading medical data...'),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

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
            const Icon(Icons.error_outline, size: 54, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyDoctorsView extends StatelessWidget {
  const _EmptyDoctorsView({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 42,
            color: AppColors.muted,
          ),
          const SizedBox(height: 8),
          const Text('No doctors found'),
          TextButton(onPressed: onClear, child: const Text('Clear filters')),
        ],
      ),
    );
  }
}
