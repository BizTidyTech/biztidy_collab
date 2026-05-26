import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/bookings_list_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/widgets/booking_card.dart';
import 'package:biztidy_mobile_app/ui/features_user/nav_bar/data/page_index_class.dart';
import 'package:biztidy_mobile_app/ui/features_user/nav_bar/views/custom_navbar.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_views/widgets/guest_user_prompt_view.dart';
import 'package:biztidy_mobile_app/ui/shared/globals.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_theme_data.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BookingsListScreen extends StatefulWidget {
  const BookingsListScreen({super.key});

  @override
  State<BookingsListScreen> createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends State<BookingsListScreen> {
  final controller = Get.put(BookingsListController());

  @override
  void initState() {
    super.initState();
    if (Globals.isLoggedIn == true) {
      controller.fetchBookingsList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalWillPopScope(
      onWillPop: () => Provider.of<CurrentPage>(context, listen: false)
          .checkCurrentPageIndex(context),
      shouldAddCallback: true,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColors.primaryThemeColor,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness:
              context.isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: context.navBarBg,
        ),
        child: GetBuilder<BookingsListController>(
          init: BookingsListController(),
          builder: (_) {
            return Scaffold(
              backgroundColor: context.bgColor,
              bottomNavigationBar: const CustomNavBar(currentPageIndx: 2),
              appBar: AppBar(
                elevation: 3,
                automaticallyImplyLeading: false,
                shadowColor: AppColors.lightGray,
                backgroundColor: AppColors.primaryThemeColor,
                title: Text(
                  AppStrings.myBookings,
                  style: AppStyles.normalStringStyle(20, AppColors.plainWhite),
                ),
              ),
              body: controller.showLoading == true
                  ? loadingWidget()
                  : Globals.isLoggedIn == true
                      ? _bookingListView(context)
                      : guestUserPromptView(context, "bookings"),
            );
          },
        ),
      ),
    );
  }

  Widget _bookingListView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: context.bgColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      child: controller.bookingsList?.isEmpty == true
          ? const Center(child: Text("No bookings found"))
          : ListView.builder(
              itemCount: controller.bookingsList?.length,
              itemBuilder: (BuildContext context, int index) {
                final booking = controller.bookingsList?[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: bookingCard(context, booking),
                );
              },
            ),
    );
  }
}
