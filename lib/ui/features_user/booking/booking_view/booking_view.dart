import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/booking_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_view/bookings_details_screen.dart';
import 'package:biztidy_mobile_app/ui/features_user/home/data/services_data.dart';
import 'package:biztidy_mobile_app/ui/features_user/home/home_view/widgets/service_card.dart';
import 'package:biztidy_mobile_app/ui/features_user/nav_bar/data/page_index_class.dart';
import 'package:biztidy_mobile_app/ui/features_user/nav_bar/views/custom_navbar.dart';
import 'package:biztidy_mobile_app/ui/shared/curved_container.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/globals.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_theme_data.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

class BookingsView extends StatefulWidget {
  const BookingsView({super.key});

  @override
  State<BookingsView> createState() => _BookingsViewState();
}

class _BookingsViewState extends State<BookingsView> {
  final controller = Get.put(BookingsController());

  @override
  Widget build(BuildContext context) {
    return ConditionalWillPopScope(
      onWillPop: () async {
        Provider.of<CurrentPage>(context, listen: false)
            .checkCurrentPageIndex(context);
        controller.clearVals();
        return false;
      },
      shouldAddCallback: true,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              context.isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarIconBrightness:
              context.isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: context.navBarBg,
        ),
        child: GetBuilder<BookingsController>(
          init: BookingsController(),
          builder: (_) {
            return Scaffold(
              backgroundColor: context.bgColor,
              bottomNavigationBar: const CustomNavBar(currentPageIndx: 1),
              appBar: AppBar(
                elevation: 3,
                automaticallyImplyLeading: false,
                shadowColor: context.dividerColor,
                surfaceTintColor: context.cardBg,
                backgroundColor: context.cardBg,
                title: Text(
                  AppStrings.bookings,
                  style: AppStyles.normalStringStyle(20, context.textPrimary),
                ),
              ),
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    CustomCurvedContainer(
                      fillColor: context.isDark
                          ? Colors.black
                          : AppColors.kPrimaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              controller.selectedService == null
                                  ? 'Select service'
                                  : "${controller.selectedService?.name} Cleaning",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: controller.selectedService == null
                                  ? AppStyles.floatingHintStringStyle(16,
                                      color: context.isDark
                                          ? Colors.white70
                                          : context.textSecondary)
                                  : AppStyles.normalStringStyle(
                                      16,
                                      context.isDark
                                          ? Colors.white
                                          : context.textPrimary),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 30,
                            width: 85,
                            child: CustomButton(
                              buttonText: controller.selectedService == null
                                  ? AppStrings.choose
                                  : AppStrings.change,
                              fontSize: 12,
                              width: 45,
                              onPressed: () {
                                _showServicesSheet(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpacer(10),
                    CustomCurvedContainer(
                      fillColor: context.isDark
                          ? Colors.white
                          : context.cardBg,
                      borderColor: AppColors.primaryThemeColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              controller.appointmentDateSelected == null
                                  ? 'Choose appointment date'
                                  : DateFormat('MMM d, y, h:mm a').format(
                                      controller.appointmentDateSelected!),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: controller.selectedService == null
                                  ? AppStyles.floatingHintStringStyle(16,
                                      color: context.isDark
                                          ? Colors.black54
                                          : context.textSecondary)
                                  : AppStyles.normalStringStyle(
                                      16,
                                      context.isDark
                                          ? Colors.black
                                          : context.textPrimary),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 30,
                            width: 85,
                            child: CustomButton(
                              buttonText:
                                  controller.appointmentDateSelected == null
                                      ? AppStrings.choose
                                      : AppStrings.change,
                              fontSize: 12,
                              width: 45,
                              onPressed: () {
                                _chooseAppointmentDate(controller);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpacer(20),
                    Row(
                      children: [
                        Text(
                          "Choose start time",
                          style: AppStyles.regularStringStyle(
                              15, context.textPrimary),
                        ),
                      ],
                    ),
                    controller.appointmentDateSelected == null
                        ? const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text("Choose a date to see available hours"),
                          )
                        : _timeSelectorWidget(),
                    const Spacer(),
                    controller.selectedService == null ||
                            controller.appointmentDateSelected == null
                        ? const SizedBox.shrink()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 40,
                                width: 125,
                                child: CustomButton(
                                  buttonText: AppStrings.contineu,
                                  fontSize: 12,
                                  width: 45,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const BookingsDetailsScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _timeSelectorWidget() {
    final List<TimeOfDay> availableTimes = [];
    for (int hour = 6; hour < 18; hour++) {
      availableTimes.add(TimeOfDay(hour: hour, minute: 0));
    }

    return controller.appointmentDateSelected == null
        ? const SizedBox.shrink()
        : Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: availableTimes.map((time) {
              final isSelected =
                  time.hour == controller.appointmentDateSelected?.hour;

              return ElevatedButton(
                onPressed: () {
                  final initTime = controller.appointmentDateSelected!;
                  final selectedDateTime = DateTime(initTime.year,
                      initTime.month, initTime.day, time.hour, 0, 0);
                  controller.changeSelectedAppointmentDate(selectedDateTime);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Colors.blue : Colors.grey,
                  foregroundColor: Colors.white,
                ),
                child: Text(DateFormat('h:mm a').format(
                  DateTime(0, 0, 0, time.hour, 0, 0),
                )),
              );
            }).toList(),
          );
  }

  Future<void> _chooseAppointmentDate(BookingsController controller) async {
    if (Globals.isLoggedIn != true) {
      Fluttertoast.showToast(
        msg: "Sign in to book an appointment",
        toastLength: Toast.LENGTH_LONG,
      );
      context.push('/signInUserView');
      return;
    }

    final initialDate = DateTime.now().add(const Duration(days: 1));

    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime.now().add(const Duration(days: 90)),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 30,
      secondsInterval: 1,
      type: OmniDateTimePickerType.date,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(maxWidth: 350, maxHeight: 650),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(Tween(begin: 0, end: 1)),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );
    logger.f("Chosen date: $dateTime");

    final setDateTime = DateTime(
      dateTime?.year ?? initialDate.year,
      dateTime?.month ?? initialDate.month,
      dateTime?.day ?? initialDate.day,
      6,
      0,
      0,
    );
    controller.changeSelectedAppointmentDate(setDateTime);
  }

  void _showServicesSheet(BuildContext context) {
    final allServicesList = commercialServices +
        residentialServices +
        industrialServices +
        specialtyServices;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: context.bgColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              child: ListView.builder(
                controller: scrollController,
                itemCount: allServicesList.length,
                itemBuilder: (BuildContext context, int index) {
                  final service = allServicesList[index];
                  return serviceCard(service, popPage: true);
                },
              ),
            );
          },
        );
      },
    );
  }
}
