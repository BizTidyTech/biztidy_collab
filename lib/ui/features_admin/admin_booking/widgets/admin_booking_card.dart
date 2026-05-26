import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_admin/admin_booking/admin_booking_list_view/admin_bookings_details_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/booking_model.dart';
import 'package:biztidy_mobile_app/ui/shared/curved_container.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget adminBookingCard(BuildContext context, BookingModel? booking) {
  return InkWell(
    onTap: () {
      logger.i("Tapped ${booking.service?.name}");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return AdminBookingDetailsScreen(booking: booking);
          },
        ),
      );
    },
    child: Card(
      child: CustomCurvedContainer(
        height: 65,
        leftPadding: 12,
        rightPadding: 12,
        fillColor: AppColors.plainWhite,
        borderColor: booking?.finalPayment != null
            ? AppColors.normalGreen
            : AppColors.transparent,
        child: Column(
          children: [
            SizedBox(
              width: screenWidth(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      booking?.service?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          AppStyles.regularStringStyle(16, AppColors.fullBlack),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Text(
                      DateFormat('MMM d, y').format(booking!.dateTime!),
                      textAlign: TextAlign.right,
                      style: AppStyles.subStringStyle(15, AppColors.fullBlack),
                    ),
                  ),
                ],
              ),
            ),
            verticalSpacer(3),
            SizedBox(
              width: screenWidth(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      booking.customer?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.regularStringStyle(
                        14,
                        AppColors.fullBlack.withOpacity(0.7),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      DateFormat('h:mm a').format(booking.dateTime!),
                      textAlign: TextAlign.right,
                      style: AppStyles.subStringStyle(
                        15,
                        AppColors.fullBlack,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
