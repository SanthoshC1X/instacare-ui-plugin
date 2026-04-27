import 'package:flutter/material.dart';
import '../common/network_image.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

/// A booking card that displays patient info, partner details,
/// service image, service name, and scheduled date/time.
///
/// Layout matches the two-section design:
/// ┌─────────────────────────────────────────┐
/// │ PatientName G/Age              In X Days│
/// │ 👤 Assigned Partner : Name      BookingID│
/// ├─────────────────────────────────────────┤
/// │ [Service Image]  Service Name           │
/// │                  🕐 Date | Time         │
/// └─────────────────────────────────────────┘
class InstaCareBookingCard extends StatelessWidget {
  /// Patient's full name.
  final String patientName;

  /// Patient gender abbreviation (e.g., "F", "M").
  final String? patientGender;

  /// Patient age.
  final int? patientAge;

  /// Assigned partner/care provider name.
  final String? partnerName;

  /// Partner's profile image URL.
  final String? partnerImageUrl;

  /// Booking ID to display.
  final String bookingId;

  /// Name of the booked service.
  final String serviceName;

  /// Service image URL.
  final String? serviceImageUrl;

  /// Formatted date/time string (e.g., "February 14, 2026 | 6:30 p.m.").
  final String dateTime;

  /// Number of days until the booking. Null for active/ongoing bookings.
  final int? daysUntil;

  /// Whether to show the partner information row. Defaults to true.
  final bool showPartnerInfo;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  const InstaCareBookingCard({
    super.key,
    required this.patientName,
    this.patientGender,
    this.patientAge,
    this.partnerName,
    this.partnerImageUrl,
    required this.bookingId,
    required this.serviceName,
    this.serviceImageUrl,
    required this.dateTime,
    this.daysUntil,
    this.showPartnerInfo = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.baseWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray200),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Top section: Patient + Partner info ──
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
              child: Column(
                children: [
                  // Row 1: Patient name + gender/age | days until OR booking ID
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Patient name + gender/age
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              patientName,
                              style: InstaCareTypography.m.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary900,
                              ),
                            ),
                            if (patientGender != null || patientAge != null) ...[
                              const SizedBox(width: 6),
                              Text(
                                _genderAge,
                                style: InstaCareTypography.s.copyWith(
                                  color: AppColors.primary800,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // "In X Days" badge OR Booking ID
                      if (daysUntil != null && daysUntil! > 0)
                        Text(
                          'In $daysUntil ${daysUntil == 1 ? 'Day' : 'Days'}',
                          style: InstaCareTypography.s.copyWith(
                            color: AppColors.gray500,
                          ),
                        )
                      else if (!showPartnerInfo) // Show booking ID when partner info is hidden
                        Text(
                          bookingId,
                          style: InstaCareTypography.r.copyWith(
                            color: AppColors.primary800,
                          ),
                        ),
                    ],
                  ),
                  // Row 2: Partner info | Booking ID (conditionally shown)
                  if (showPartnerInfo) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildPartnerAvatar(),
                        const SizedBox(width: 6),
                        // Partner name
                        Expanded(
                          child: Text(
                            partnerName != null && partnerName!.isNotEmpty
                                ? 'Assigned Partner : $partnerName'
                                : 'Partner not assigned',
                            style: InstaCareTypography.s.copyWith(
                              color: AppColors.gray500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Booking ID
                        Text(
                          bookingId,
                          style: InstaCareTypography.r.copyWith(
                            color: AppColors.primary800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // ── Divider ──
            Container(height: 1, color: AppColors.gray200),
            // ── Bottom section: Service image + name + time ──
            Row(
                children: [
                  // Service image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(11),
                    ),
                    child: SizedBox(
                      width: 120,
                      height: 80,
                      child: _buildServiceImage(),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Service name + date/time
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serviceName,
                            style: InstaCareTypography.m.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary900,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_outlined,
                                size: 14,
                                color: AppColors.gray500,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  dateTime,
                                  style: InstaCareTypography.s.copyWith(
                                    color: AppColors.gray500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String get _genderAge {
    final parts = <String>[];
    if (patientGender != null && patientGender!.isNotEmpty) {
      parts.add(patientGender!);
    }
    if (patientAge != null) {
      parts.add('$patientAge');
    }
    return parts.join('/');
  }
  Widget _buildServiceImage() {
    if (serviceImageUrl != null && serviceImageUrl!.isNotEmpty) {
      return InstaCareNetworkImage(
        imageUrl: serviceImageUrl!,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.zero,
        errorWidget: _placeholderImage(),
      );
    }
    return _placeholderImage();
  }

   Widget _buildPartnerAvatar() {
    if (partnerImageUrl != null && partnerImageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 12,
        backgroundImage: NetworkImage(partnerImageUrl!),
        backgroundColor: AppColors.gray200,
      );
    }
    return const CircleAvatar(
      radius: 12,
      backgroundColor: AppColors.secondary300,
      child: Icon(
        Icons.person,
        size: 14,
        color: AppColors.primary800,
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      color: AppColors.gray100,
      child: const Center(
        child: Icon(
          Icons.medical_services_outlined,
          size: 28,
          color: AppColors.gray500,
        ),
      ),
    );
  }
}
