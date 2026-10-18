import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MedicalAppointmentApp());

class AppColors {
  static const ink = Color(0xFF191D31);
  static const muted = Color(0xFF8C8E98);
  static const teal = Color(0xFF2BACBE);
  static const deepTeal = Color(0xFF0B8FAC);
  static const softTeal = Color(0xFF7BC1B7);
  static const surface = Color(0xFFFBFBFD);
  static const tile = Color(0xFFF9F9F9);
  static const hint = Color(0xFFA7AEC1);
}

class MedicalAppointmentApp extends StatelessWidget {
  const MedicalAppointmentApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
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
  );
}

class Doctor {
  const Doctor(this.name, this.specialty, this.location, this.image);
  final String name;
  final String specialty;
  final String location;
  final String image;
}

const nearbyDoctors = <Doctor>[
  Doctor(
    'Dr. Emmly Lestiryno',
    'General Practitioner',
    '3167 Durgan Shores - 500M from you',
    'assets/images/doctor_nearby_1.png',
  ),
  Doctor(
    'Dr. Sonja Littel',
    'Dental Specialist',
    '950 Sigrid Port - 753M from you',
    'assets/images/doctor_nearby_2.png',
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  final favorites = <String>{};
  String selectedCategory = 'Tooth';

  List<Doctor> get visibleDoctors {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) return nearbyDoctors;
    return nearbyDoctors
        .where(
          (d) =>
              d.name.toLowerCase().contains(query) ||
              d.specialty.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void openAppointment() => Navigator.of(context)
      .push(MaterialPageRoute<void>(builder: (_) => const AppointmentScreen()));

  void message(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: SizedBox(
            width: constraints.maxWidth > 420 ? 375 : constraints.maxWidth,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 34),
              children: [
                const _GreetingHeader(),
                const SizedBox(height: 24),
                _SearchField(
                  controller: searchController,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 24),
                _AppointmentCard(onTap: openAppointment),
                const SizedBox(height: 25),
                _SectionTitle(
                  title: 'Health Services',
                  onTap: () => message('All health services'),
                ),
                const SizedBox(height: 16),
                _CategoryStrip(
                  selected: selectedCategory,
                  onSelected: (value) =>
                      setState(() => selectedCategory = value),
                ),
                const SizedBox(height: 24),
                _SectionTitle(
                  title: 'Nearby Doctor',
                  onTap: () => message('All nearby doctors'),
                ),
                const SizedBox(height: 12),
                if (visibleDoctors.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 28),
                    child: Center(child: Text('No doctors found')),
                  )
                else
                  ...visibleDoctors.map(
                    (doctor) => Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: _DoctorRow(
                        doctor: doctor,
                        isFavorite: favorites.contains(doctor.name),
                        onFavorite: () => setState(() {
                          if (!favorites.add(doctor.name)) {
                            favorites.remove(doctor.name);
                          }
                        }),
                        onTap: openAppointment,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      ClipOval(
        child: Image.asset(
          'assets/images/profile.png',
          width: 44,
          height: 44,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(width: 8),
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, Jonathan',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              'May you always be healthy',
              style: TextStyle(color: AppColors.muted, fontSize: 10),
            ),
          ],
        ),
      ),
      IconButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You have one new notification.')),
        ),
        icon: const Badge(
          smallSize: 8,
          backgroundColor: Color(0xFFE50000),
          child: Icon(Icons.notifications_none_rounded, size: 24),
        ),
      ),
    ],
  );
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: 'Search something',
      hintStyle: const TextStyle(color: AppColors.hint, fontSize: 14),
      prefixIcon: const Icon(
        Icons.search_rounded,
        color: AppColors.hint,
        size: 26,
      ),
      suffixIcon: IconButton(
        onPressed: () => ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Filter options opened.'))),
        icon: const Icon(Icons.tune_rounded, color: AppColors.hint),
      ),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.tile),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.tile),
      ),
    ),
  );
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: SizedBox(
      height: 198,
      child: Stack(
        children: [
          Positioned.fill(
            bottom: 25,
            child: Container(
              padding: const EdgeInsets.fromLTRB(22, 23, 22, 42),
              decoration: BoxDecoration(
                color: AppColors.teal,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        'Appointment',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          children: [
                            _WhiteInfoLine(
                              icon: Icons.calendar_month_outlined,
                              text: '22 October, 2023',
                            ),
                            SizedBox(height: 12),
                            _WhiteInfoLine(
                              icon: Icons.schedule_rounded,
                              text: '08:00 AM - 10.30 AM',
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: AppColors.teal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 22,
            right: 22,
            bottom: 0,
            child: Container(
              height: 67,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1C000000),
                    blurRadius: 36,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/appointment_card_doctor.png',
                      width: 43,
                      height: 43,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. Richar Kandowen',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Child Specialist',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chat_bubble_outline_rounded, size: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _WhiteInfoLine extends StatelessWidget {
  const _WhiteInfoLine({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: Colors.white, size: 20),
      const SizedBox(width: 8),
      Expanded(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ],
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.teal,
          padding: EdgeInsets.zero,
          minimumSize: const Size(36, 24),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text('See All', style: TextStyle(fontSize: 12)),
      ),
    ],
  );
}

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip({required this.selected, required this.onSelected});
  final String selected;
  final ValueChanged<String> onSelected;

  static const categories = [
    ('Tooth', 'assets/images/category_tooth.png'),
    ('Eye', 'assets/images/category_eye.png'),
    ('Lungs', 'assets/images/category_lungs.png'),
    ('Ear', 'assets/images/category_ear.png'),
  ];

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: categories.map((category) {
      final active = selected == category.$1;
      return InkWell(
        onTap: () => onSelected(category.$1),
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 64,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.teal.withValues(alpha: .13)
                      : AppColors.tile,
                  borderRadius: BorderRadius.circular(10),
                  border: active ? Border.all(color: AppColors.teal) : null,
                ),
                child: Image.asset(category.$2),
              ),
              const SizedBox(height: 8),
              Text(
                category.$1,
                style: TextStyle(
                  color: active ? AppColors.teal : AppColors.muted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

class _DoctorRow extends StatelessWidget {
  const _DoctorRow({
    required this.doctor,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
  });

  final Doctor doctor;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Image.asset(
            doctor.image,
            width: 46,
            height: 46,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                doctor.specialty,
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 18,
                    color: AppColors.teal,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      doctor.location,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onFavorite,
          constraints: const BoxConstraints.tightFor(width: 28, height: 28),
          padding: EdgeInsets.zero,
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? const Color(0xFFE50000) : AppColors.muted,
            size: 21,
          ),
        ),
      ],
    ),
  );
}

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});
  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  static const times = ['10.00 AM', '11.00 AM', '12.00 PM'];
  static const dates = ['Sun 4', 'Mon 5', 'Tue 6'];
  String selectedTime = '11.00 AM';
  String selectedDate = 'Sun 4';

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(
      textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
    ),
    child: Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => Center(
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
                      _AppointmentAppBar(
                        onBack: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(height: 32),
                      const _DoctorSummary(),
                      const SizedBox(height: 38),
                      const Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Worem ipsum dolor sit amet, consectetur adipiscing elit. '
                        'Nunc vulputate libero et velit interdum, ac aliquet odio '
                        'mattis. Class aptent taciti sociosqu ad litora torquent '
                        'per conubia nostra, per inceptos himenaeos. Curabitur '
                        'tempus urna at turpis condimentum lobortis. Ut commodo '
                        'efficitur neque. Ut diam quam, semper iaculis condimentum '
                        'ac, vestibulum eu nisl.',
                        style: TextStyle(
                          color: Color(0xFF858585),
                          fontSize: 13,
                          height: 1.32,
                        ),
                      ),
                      const SizedBox(height: 42),
                      _ChoiceSection(
                        title: 'Working Hours',
                        values: times,
                        selected: selectedTime,
                        onSelected: (value) =>
                            setState(() => selectedTime = value),
                      ),
                      const SizedBox(height: 44),
                      _ChoiceSection(
                        title: 'Date',
                        values: dates,
                        selected: selectedDate,
                        onSelected: (value) =>
                            setState(() => selectedDate = value),
                      ),
                      const SizedBox(height: 78),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: FilledButton(
                          onPressed: _bookAppointment,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.deepTeal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Book an Appointment',
                            style: TextStyle(
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
          ),
        ),
      ),
    ),
  );

  void _bookAppointment() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(
        Icons.check_circle_rounded,
        color: AppColors.deepTeal,
        size: 48,
      ),
      title: const Text('Appointment booked'),
      content: Text(
        'Your appointment with Dr. Upul is scheduled for '
        '$selectedDate at $selectedTime.',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          style: FilledButton.styleFrom(backgroundColor: AppColors.deepTeal),
          child: const Text('Done'),
        ),
      ],
    ),
  );
}

class _AppointmentAppBar extends StatelessWidget {
  const _AppointmentAppBar({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 40,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: onBack,
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 25),
          ),
        ),
        const Text(
          'Appointment',
          style: TextStyle(
            color: AppColors.deepTeal,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -.52,
          ),
        ),
      ],
    ),
  );
}

class _DoctorSummary extends StatelessWidget {
  const _DoctorSummary();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/images/appointment_doctor.png',
          width: 132,
          height: 132,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(width: 21),
      Expanded(
        child: SizedBox(
          height: 116,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Dr.Upul',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ...[
                    Icons.chat_bubble_outline_rounded,
                    Icons.phone_outlined,
                    Icons.videocam_outlined,
                  ].map(
                    (icon) => Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: InkWell(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Contact option selected.'),
                          ),
                        ),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE5F4F1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, size: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                'Denteeth',
                style: TextStyle(
                  color: AppColors.softTeal,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Payment',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      r'$120.00',
                      style: TextStyle(
                        color: AppColors.softTeal,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _ChoiceSection extends StatelessWidget {
  const _ChoiceSection({
    required this.title,
    required this.values,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<String> values;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('All $title options'))),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: EdgeInsets.zero,
              minimumSize: const Size(48, 28),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('See All', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      const SizedBox(height: 22),
      Row(
        children: [
          for (var index = 0; index < values.length; index++) ...[
            if (index > 0) const SizedBox(width: 15),
            Expanded(
              child: _ChoiceButton(
                label: values[index],
                selected: selected == values[index],
                onTap: () => onSelected(values[index]),
              ),
            ),
          ],
        ],
      ),
    ],
  );
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? AppColors.deepTeal : const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontSize: 20,
          ),
        ),
      ),
    ),
  );
}
