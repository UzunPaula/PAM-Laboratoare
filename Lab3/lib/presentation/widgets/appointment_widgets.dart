import 'package:flutter/material.dart';
import 'package:medical_appointment_app/core/app_colors.dart';
import 'package:medical_appointment_app/data/models/medical_data.dart';

class AppointmentHeader extends StatelessWidget {
  const AppointmentHeader({
    super.key,
    required this.title,
    required this.onBack,
  });

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              tooltip: 'Back',
              onPressed: onBack,
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 25),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
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
}

class DoctorSummary extends StatelessWidget {
  const DoctorSummary({
    super.key,
    required this.doctor,
    required this.payment,
    required this.imageAsset,
  });

  final AppointmentDoctor doctor;
  final PaymentInfo payment;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    final actions = <IconData>[
      if (doctor.canMessage) Icons.chat_bubble_outline_rounded,
      if (doctor.canCall) Icons.phone_outlined,
      if (doctor.canVideoCall) Icons.videocam_outlined,
    ];

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imageAsset,
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
                    Expanded(
                      child: Text(
                        doctor.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    ...actions.map(
                      (icon) => Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: InkWell(
                          onTap: () => ScaffoldMessenger.of(context)
                              .showSnackBar(
                                const SnackBar(
                                  content: Text('Contact option selected.'),
                                ),
                              ),
                          borderRadius: BorderRadius.circular(30),
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
                Text(
                  doctor.clinic,
                  style: const TextStyle(
                    color: AppColors.softTeal,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          payment.label,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        payment.formatted,
                        style: const TextStyle(
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
}

class ChoiceSection extends StatelessWidget {
  const ChoiceSection({
    super.key,
    required this.group,
    required this.selectedId,
    required this.onSelected,
  });

  final OptionGroup group;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                group.title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (group.showAll)
              TextButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('All ${group.title} options')),
                ),
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
            for (var index = 0; index < group.slots.length; index++) ...[
              if (index > 0) const SizedBox(width: 15),
              Expanded(
                child: ChoiceButton(
                  label: group.slots[index].label,
                  selected: selectedId == group.slots[index].id,
                  onTap: () => onSelected(group.slots[index].id),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class ChoiceButton extends StatelessWidget {
  const ChoiceButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
}
