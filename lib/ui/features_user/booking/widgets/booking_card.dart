import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/bookings_list_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_list_view/bookings_details_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/booking_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_view/job_rating_screen.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Widget bookingCard(BuildContext context, BookingModel? booking) {
  if (booking == null) return const SizedBox.shrink();

  final ctrl = Get.find<BookingsListController>();
  final needsRating =
      !booking.isRated && ctrl.isJobCompleted(booking.bookingId);

  return GestureDetector(
    onTap: () {
      logger.i('Tapped ${booking.service?.name}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookingDetailsScreen(booking: booking),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: booking.isRated
              ? AppColors.normalGreen.withOpacity(0.4)
              : needsRating
                  ? const Color(0xFFF59E0B).withOpacity(0.4)
                  : AppColors.lightGray,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: service name + date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  booking.service?.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      AppStyles.regularStringStyle(16, context.textPrimary),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  DateFormat('MMM d, y').format(booking.dateTime!),
                  style: AppStyles.subStringStyle(12, AppColors.darkGray),
                ),
              ),
            ],
          ),
          verticalSpacer(6),
          // Row 2: customer name + time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.person_outline_rounded,
                        size: 14, color: AppColors.darkGray),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        booking.customer?.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.subStringStyle(
                            13, AppColors.darkGray),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.access_time_rounded,
                      size: 14, color: AppColors.darkGray),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('h:mm a').format(booking.dateTime!),
                    style:
                        AppStyles.subStringStyle(12, AppColors.darkGray),
                  ),
                ],
              ),
            ],
          ),
          // Row 3: rating badge
          if (booking.isRated) ...[
            verticalSpacer(8),
            Row(
              children: [
                ...List.generate(
                  5,
                  (i) => Icon(
                    i < (booking.clientRating ?? 0).floor()
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: const Color(0xFFF59E0B),
                    size: 15,
                  ),
                ),
                horizontalSpacer(6),
                Text(
                  'You rated ${booking.clientRating?.toStringAsFixed(1)}/5',
                  style: AppStyles.subStringStyle(12, AppColors.darkGray),
                ),
              ],
            ),
          ] else if (needsRating) ...[
            verticalSpacer(8),
            GestureDetector(
              onTap: () => JobRatingSheet.show(context, booking),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFFF59E0B).withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_outline_rounded,
                        color: Color(0xFFF59E0B), size: 14),
                    horizontalSpacer(4),
                    Text(
                      'Rate your clean',
                      style: AppStyles.subStringStyle(
                          12, const Color(0xFFB45309)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
