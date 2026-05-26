// ignore_for_file: must_be_immutable
import 'dart:async';

import 'package:biztidy_mobile_app/app/services/firebase_service.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/bookings_list_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/booking_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_view/job_photos_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_view/job_rating_screen.dart';
import 'package:biztidy_mobile_app/ui/shared/booking_key_text_value.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_theme_data.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key, required this.booking});
  final BookingModel booking;

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  final controller = Get.put(BookingsListController());
  late BookingModel _booking;

  // Real-time AgentJob stream
  StreamSubscription<Map<String, dynamic>?>? _jobSub;
  Map<String, dynamic>? _jobData;

  @override
  void initState() {
    super.initState();
    _booking = widget.booking;
    _subscribeToJob();
  }

  void _subscribeToJob() {
    if (_booking.bookingId == null) return;
    _jobSub = FirebaseService()
        .streamAgentJob(_booking.bookingId!)
        .listen((data) {
      if (mounted) setState(() => _jobData = data);
    });
  }

  @override
  void dispose() {
    _jobSub?.cancel();
    super.dispose();
  }

  // ── Derived helpers from live job data ────────────────────────────────────
  String get _jobStatus => _jobData?['status'] as String? ?? 'pending';
  bool get _jobCompleted => _jobStatus == 'completed';
  bool get _jobStarted =>
      _jobStatus == 'in_progress' || _jobStatus == 'completed';

  List<String> get _beforePhotos =>
      (_jobData?['beforePhotoUrls'] as List?)?.cast<String>() ?? [];
  List<String> get _afterPhotos =>
      (_jobData?['afterPhotoUrls'] as List?)?.cast<String>() ?? [];
  List<String> get _beforeVideos =>
      (_jobData?['beforeVideoUrls'] as List?)?.cast<String>() ?? [];
  List<String> get _afterVideos =>
      (_jobData?['afterVideoUrls'] as List?)?.cast<String>() ?? [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingsListController>(
      builder: (_) {
        // Sync rating from controller after submitRating
        final fresh = controller.bookingsList
            ?.firstWhereOrNull((b) => b.bookingId == _booking.bookingId);
        if (fresh != null && fresh.isRated && !_booking.isRated) {
          _booking = fresh;
        }

        final needsRating = !_booking.isRated && _jobCompleted;

        return GestureDetector(
          onTap: () =>
              SystemChannels.textInput.invokeMethod('TextInput.hide'),
          child: Scaffold(
            backgroundColor: context.bgColor,
            appBar: AppBar(
              elevation: 3,
              shadowColor: context.dividerColor,
              surfaceTintColor: context.cardBg,
              backgroundColor: context.cardBg,
              title: Text(
                AppStrings.bookingDetails,
                style: AppStyles.normalStringStyle(20, context.textPrimary),
              ),
            ),
            body: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  // ── Booking info card ────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    width: screenWidth(context),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10)),
                      color: AppColors.kPrimaryColor,
                    ),
                    child: Column(
                      children: [
                        keyTextValue(context, AppStrings.service,
                            '${_booking.service?.name ?? ''} Cleaning'),
                        keyTextValue(
                          context,
                          'Amount Paid',
                          '${_booking.country == 'USA' ? '\$' : '₦'}'
                          '${NumberFormat('#,###').format(double.tryParse(_booking.depositPayment?.amount ?? '0') ?? 0)}',
                        ),
                        keyTextValue(context, 'Location',
                            _booking.locationName ?? ''),
                        keyTextValue(context, 'Address',
                            _booking.locationAddress ?? ''),
                        keyTextValue(
                            context, 'Country', _booking.country ?? ''),
                        keyTextValue(context, 'Phone No',
                            _booking.customer?.phoneNumber ?? ''),
                        keyTextValue(
                            context, 'Rooms', '${_booking.rooms ?? ''}'),
                        keyTextValue(context, 'Duration',
                            '${_booking.duration ?? ''} hours'),
                        keyTextValue(
                          context,
                          'Date',
                          DateFormat('MMM d, y').format(
                              _booking.dateTime ?? DateTime.now()),
                        ),
                        keyTextValue(
                          context,
                          'Time',
                          DateFormat('h:mm a').format(
                              _booking.dateTime ?? DateTime.now()),
                        ),
                        keyTextValue(
                          context,
                          'Total Cost',
                          _booking.totalCalculatedServiceCharge == null
                              ? 'Pending'
                              : '${_booking.country == 'USA' ? '\$' : '₦'}'
                                '${NumberFormat('#,###').format(_booking.totalCalculatedServiceCharge)}',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Confirmed icon ───────────────────────────────────────
                  Icon(CupertinoIcons.check_mark_circled,
                      color: AppColors.normalGreen, size: 56),
                  const SizedBox(height: 8),
                  Text(
                    'Full payment received. Your booking is confirmed!',
                    textAlign: TextAlign.center,
                    style: AppStyles.regularStringStyle(
                        15, context.textPrimary),
                  ),

                  const SizedBox(height: 24),

                  // ── Job status badge ─────────────────────────────────────
                  _jobStatusBadge(),

                  const SizedBox(height: 24),

                  // ── Job Photos section ───────────────────────────────────
                  _jobPhotosSection(),

                  const SizedBox(height: 24),

                  // ── Rating section ───────────────────────────────────────
                  if (_booking.isRated)
                    _ratingDisplay()
                  else if (needsRating)
                    _ratingCta(context),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Job status badge ───────────────────────────────────────────────────────
  Widget _jobStatusBadge() {
    Color color;
    String label;
    IconData icon;
    switch (_jobStatus) {
      case 'pending':
        color = const Color(0xFFF59E0B);
        label = 'Finding your cleaner…';
        icon = Icons.search_rounded;
        break;
      case 'accepted':
        color = AppColors.primaryThemeColor;
        label = 'Cleaner assigned — on the way';
        icon = Icons.directions_walk_rounded;
        break;
      case 'in_progress':
        color = AppColors.primaryThemeColor;
        label = 'Cleaning in progress';
        icon = Icons.cleaning_services_rounded;
        break;
      case 'completed':
        color = AppColors.normalGreen;
        label = 'Job completed';
        icon = Icons.check_circle_outline_rounded;
        break;
      default:
        color = AppColors.darkGray;
        label = 'Status unknown';
        icon = Icons.help_outline_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Text(label,
              style: AppStyles.regularStringStyle(14, color)),
        ],
      ),
    );
  }

  // ── Job Photos & Videos section ────────────────────────────────────────────
  Widget _jobPhotosSection() {
    final hasAnyMedia = _beforePhotos.isNotEmpty ||
        _afterPhotos.isNotEmpty ||
        _beforeVideos.isNotEmpty ||
        _afterVideos.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.dividerColor),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.photo_library_outlined,
                  color: AppColors.primaryThemeColor, size: 20),
              const SizedBox(width: 8),
              Text('Job Photos & Videos',
                  style: AppStyles.keyStringStyle(
                      15, context.textPrimary)),
            ],
          ),
          verticalSpacer(4),
          Text(
            'Captured by your agent before and after cleaning.',
            style: AppStyles.subStringStyle(12, AppColors.darkGray),
          ),
          verticalSpacer(16),

          if (!_jobStarted)
            _emptyMediaState(
              'Photos will appear once your agent starts the job.',
              Icons.hourglass_empty_rounded,
            )
          else if (!hasAnyMedia)
            _emptyMediaState(
              'Your agent has not uploaded photos yet.',
              Icons.image_not_supported_outlined,
            )
          else ...[
            // BEFORE
            JobMediaGrid(
              photoUrls: _beforePhotos,
              videoUrls: _beforeVideos,
              label: 'BEFORE',
              labelColor: const Color(0xFFFF6B35),
            ),
            verticalSpacer(16),
            // AFTER
            JobMediaGrid(
              photoUrls: _afterPhotos,
              videoUrls: _afterVideos,
              label: 'AFTER',
              labelColor: AppColors.normalGreen,
            ),
          ],
        ],
      ),
    );
  }

  Widget _emptyMediaState(String message, IconData icon) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Icon(icon, color: AppColors.lightGray, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message,
                  style:
                      AppStyles.subStringStyle(13, AppColors.darkGray)),
            ),
          ],
        ),
      );

  // ── Already-rated card ─────────────────────────────────────────────────────
  Widget _ratingDisplay() {
    final rating = _booking.clientRating ?? 0;
    final review = _booking.clientReview;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.normalGreen.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppColors.normalGreen.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.verified_rounded,
                color: AppColors.normalGreen, size: 18),
            const SizedBox(width: 6),
            Text('Your rating',
                style: AppStyles.regularStringStyle(
                    14, AppColors.normalGreen)),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            ...List.generate(
              5,
              (i) => Icon(
                i < rating.floor()
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: const Color(0xFFF59E0B),
                size: 26,
              ),
            ),
            const SizedBox(width: 8),
            Text('${rating.toStringAsFixed(1)} / 5',
                style: AppStyles.keyStringStyle(
                    15, context.textPrimary)),
          ]),
          if (review != null && review.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('"$review"',
                style:
                    AppStyles.subStringStyle(14, AppColors.darkGray)),
          ],
        ],
      ),
    );
  }

  // ── Rate-now CTA card ──────────────────────────────────────────────────────
  Widget _ratingCta(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFFF59E0B).withOpacity(0.4)),
      ),
      child: Column(
        children: [
          const Icon(Icons.star_half_rounded,
              color: Color(0xFFF59E0B), size: 36),
          const SizedBox(height: 8),
          Text('How did your clean go?',
              style: AppStyles.regularStringStyle(
                  15, context.textPrimary)),
          const SizedBox(height: 4),
          Text(
            'Your rating helps us maintain quality and unlock '
            'better pay for great agents.',
            textAlign: TextAlign.center,
            style: AppStyles.subStringStyle(13, AppColors.darkGray),
          ),
          const SizedBox(height: 14),
          CustomButton(
            buttonText: 'Rate this clean',
            width: 200,
            onPressed: () async {
              final rated =
                  await JobRatingSheet.show(context, _booking);
              if (rated) setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
