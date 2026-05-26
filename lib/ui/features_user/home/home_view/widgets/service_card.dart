import 'package:biztidy_mobile_app/app/helpers/sharedprefs.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/booking_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/home/home_model/services_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/nav_bar/data/page_index_class.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Widget serviceCard(ServiceModel service, {bool? popPage}) {
  return Builder(builder: (context) {
    return FutureBuilder(
      future: getLocallySavedUserDetails(),
      builder: (context, snapshot) {
        final isUSA = snapshot.data?.country == 'USA';
        final priceDisplay = isUSA
            ? (service.usdCost != null
                ? '\$${NumberFormat("#,###").format(service.usdCost)}'
                : '')
            : (service.baseCost != null
                ? '₦${NumberFormat("#,###").format(service.baseCost)}'
                : '');

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                Image.asset(
                  service.imageUrl ?? '',
                  fit: BoxFit.cover,
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.65),
                      ],
                      stops: const [0.45, 1.0],
                    ),
                  ),
                ),
                // Bottom info row
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${service.name} Cleaning",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: AppStyles.regularStringStyle(
                                  15, AppColors.plainWhite),
                            ),
                            if (priceDisplay.isNotEmpty) ...[
                              verticalSpacer(2),
                              Text(
                                priceDisplay,
                                style: AppStyles.normalStringStyle(
                                    13, AppColors.kPrimaryColor),
                              ),
                            ],
                          ],
                        ),
                      ),
                      horizontalSpacer(10),
                      SizedBox(
                        height: 34,
                        child: CustomButton(
                          buttonText: AppStrings.book,
                          fontSize: 13,
                          width: 80,
                          height: 34,
                          borderRadius: 20,
                          onPressed: () {
                            Get.put(BookingsController())
                                .changeSelectedService(service);
                            Provider.of<CurrentPage>(context, listen: false)
                                .setCurrentPageIndex(1);
                            popPage == true
                                ? context.pop()
                                : context.push('/bookingsPage');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  });
}
