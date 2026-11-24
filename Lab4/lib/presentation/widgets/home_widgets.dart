import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medical_appointment_app/core/app_colors.dart';
import 'package:medical_appointment_app/domain/entities/feed.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({
    super.key,
    required this.user,
    required this.hasUnread,
  });

  final UserProfile user;
  final bool hasUnread;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: _NetworkImage(
            url: user.avatarUrl,
            fallbackAsset: 'assets/images/profile.png',
            width: 44,
            height: 44,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.greeting,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                user.subtitle,
                style: const TextStyle(color: AppColors.muted, fontSize: 10),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You have one new notification.')),
          ),
          icon: Badge(
            isLabelVisible: hasUnread,
            smallSize: 8,
            backgroundColor: const Color(0xFFE50000),
            child: const Icon(Icons.notifications_none_rounded, size: 24),
          ),
        ),
      ],
    );
  }
}

class DoctorSearchField extends StatelessWidget {
  const DoctorSearchField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onFilter,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.hint, fontSize: 14),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.hint,
          size: 26,
        ),
        suffixIcon: IconButton(
          tooltip: 'Filter and sort',
          onPressed: onFilter,
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
}

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key, required this.data, required this.onTap});

  final HomeAppointment data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                    Row(
                      children: [
                        Text(
                          data.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              WhiteInfoLine(
                                icon: Icons.calendar_month_outlined,
                                text: data.date,
                              ),
                              const SizedBox(height: 12),
                              WhiteInfoLine(
                                icon: Icons.schedule_rounded,
                                text: data.time,
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
                      child: _NetworkImage(
                        url: data.doctor.avatarUrl,
                        fallbackAsset:
                            'assets/images/appointment_card_doctor.png',
                        width: 43,
                        height: 43,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.doctor.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            data.doctor.specialty,
                            style: const TextStyle(
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
}

class WhiteInfoLine extends StatelessWidget {
  const WhiteInfoLine({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
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
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
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
}

class CategoryStrip extends StatelessWidget {
  const CategoryStrip({
    super.key,
    required this.services,
    required this.selectedId,
    required this.onSelected,
  });

  final List<HealthService> services;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: services
          .map((service) {
            final active = selectedId == service.id;
            return InkWell(
              onTap: () => onSelected(service.id),
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
                        border: active
                            ? Border.all(color: AppColors.teal)
                            : null,
                      ),
                      child: SvgPicture.network(
                        service.iconUrl,
                        width: 32,
                        height: 32,
                        placeholderBuilder: (_) =>
                            Image.asset(_serviceAsset(service.id)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service.name,
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
          })
          .toList(growable: false),
    );
  }

  String _serviceAsset(String id) {
    return switch (id) {
      'eye' => 'assets/images/category_eye.png',
      'lungs' => 'assets/images/category_lungs.png',
      'ear' => 'assets/images/category_ear.png',
      _ => 'assets/images/category_tooth.png',
    };
  }
}

class DoctorRow extends StatelessWidget {
  const DoctorRow({
    super.key,
    required this.doctor,
    required this.onFavorite,
    required this.onTap,
  });

  final Doctor doctor;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: _NetworkImage(
              url: doctor.avatarUrl,
              fallbackAsset: doctor.id == 'doctor-002'
                  ? 'assets/images/doctor_nearby_2.png'
                  : 'assets/images/doctor_nearby_1.png',
              width: 46,
              height: 46,
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
                        doctor.distance,
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
            tooltip: doctor.isFavorite ? 'Remove favorite' : 'Add favorite',
            onPressed: onFavorite,
            constraints: const BoxConstraints.tightFor(width: 28, height: 28),
            padding: EdgeInsets.zero,
            icon: Icon(
              doctor.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: doctor.isFavorite
                  ? const Color(0xFFE50000)
                  : AppColors.muted,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkImage extends StatelessWidget {
  const _NetworkImage({
    required this.url,
    required this.fallbackAsset,
    required this.width,
    required this.height,
  });

  final String url;
  final String fallbackAsset;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Image.asset(
        fallbackAsset,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return SizedBox(
          width: width,
          height: height,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
    );
  }
}
