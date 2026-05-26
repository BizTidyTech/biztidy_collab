// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:biztidy_mobile_app/app/helpers/location_services.dart';
import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_view/widgets/input_widget.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/booking_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_view/location_picker_view.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_theme_data.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker_google/place_picker_google.dart';

class BookingsDetailsScreen extends StatefulWidget {
  const BookingsDetailsScreen({super.key});

  @override
  State<BookingsDetailsScreen> createState() => _BookingsDetailsScreenState();
}

class _BookingsDetailsScreenState extends State<BookingsDetailsScreen> {
  double _durationValue = 1.0, _roomSqFtValue = 100.0;
  final ValueNotifier<bool> _isLocationLoading = ValueNotifier<bool>(false);

  final controller = Get.put(BookingsController());

  @override
  void dispose() {
    _isLocationLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingsController>(
      init: BookingsController(),
      builder: (_) {
        return GestureDetector(
          onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
          child: Scaffold(
            backgroundColor: context.bgColor,
            appBar: AppBar(
              elevation: 3,
              shadowColor: context.dividerColor,
              surfaceTintColor: context.cardBg,
              backgroundColor: context.cardBg,
              title: Text(
                AppStrings.bookings,
                style: AppStyles.normalStringStyle(20, context.textPrimary),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        "Location address/Landmark name",
                        style: AppStyles.subStringStyle(
                          12,
                          context.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  verticalSpacer(5),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isLocationLoading,
                    builder: (context, isLoading, child) {
                      return CustomButton(
                        width: screenWidth(context),
                        onPressed: () async {
                          if (isLoading != true) {
                            _isLocationLoading.value = true;
                            logger.f("Capturing location . . .");
                            LatLng latLng;
                            if (controller.userLocationData?.latLng == null) {
                              final locationCaptured =
                                  await LocationServices().captureLocation(
                                context,
                              );
                              latLng = LatLng(
                                locationCaptured?.latitude ?? 37.4219983,
                                locationCaptured?.longitude ?? -122.084,
                              );
                            } else {
                              latLng = LatLng(
                                controller.userLocationData!.latLng!.latitude,
                                controller.userLocationData!.latLng!.longitude,
                              );
                            }
                            _isLocationLoading.value = false;

                            final LocationResult? locationResult =
                                await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationPickerView(
                                  latitude: latLng.latitude,
                                  longitude: latLng.longitude,
                                ),
                              ),
                            );
                            if (locationResult != null) {
                              controller.saveSelectedLocation(locationResult);
                            }
                            logger.f(
                                "Address: ${controller.userLocationData?.formattedAddress}");
                          }
                        },
                        color: context.cardBg,
                        borderColor: AppColors.primaryThemeColor,
                        child: isLoading
                            ? loadingWidget()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_searching_rounded,
                                    color: AppColors.deepBlue,
                                  ),
                                  horizontalSpacer(10),
                                  Text(
                                    "Pick your location",
                                    style: AppStyles.regularStringStyle(
                                      15,
                                      AppColors.deepBlue,
                                    ),
                                  ),
                                ],
                              ),
                      );
                    },
                  ),
                  verticalSpacer(10),
                  if (controller.userLocationData != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        controller.userLocationData!.formattedAddress ?? '',
                        style: AppStyles.regularStringStyle(
                          15,
                          context.textPrimary,
                        ),
                      ),
                    ),
                  inputWidget(
                    titleText: "Contact phone number",
                    textEditingController: controller.phoneController,
                    hintText: 'Enter the phone number to contact',
                    keyboardType: TextInputType.phone,
                  ),
                  verticalSpacer(6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Duration",
                        style:
                            AppStyles.subStringStyle(12, context.textPrimary),
                      ),
                      Text(
                        "${_durationValue.toInt()} hours",
                        style: AppStyles.regularStringStyle(
                            12, AppColors.deepBlue),
                      ),
                    ],
                  ),
                  Slider(
                    value: _durationValue,
                    min: 1.0,
                    max: 6.0,
                    divisions: 5,
                    label: _durationValue.toString(),
                    thumbColor: AppColors.primaryThemeColor,
                    activeColor: AppColors.kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        _durationValue = value;
                      });
                    },
                  ),
                  inputWidget(
                    titleText: "No. of rooms",
                    textEditingController: controller.roomsCountController,
                    hintText: 'How many rooms are to be cleaned?',
                    keyboardType: TextInputType.number,
                  ),
                  verticalSpacer(6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Room sq ft",
                        style:
                            AppStyles.subStringStyle(12, context.textPrimary),
                      ),
                      Text(
                        "${_roomSqFtValue.toInt()} sq ft",
                        style: AppStyles.regularStringStyle(
                            12, AppColors.deepBlue),
                      ),
                    ],
                  ),
                  Slider(
                    value: _roomSqFtValue,
                    min: 100.0,
                    max: 1000.0,
                    divisions: 50,
                    label: _roomSqFtValue.toString(),
                    thumbColor: AppColors.primaryThemeColor,
                    activeColor: AppColors.kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        _roomSqFtValue = value;
                      });
                    },
                  ),
                  inputWidget(
                    titleText: "Further information",
                    textEditingController: controller.descriptionController,
                    hintText: 'Enter any additional information',
                    maxLines: 5,
                    textInputAction: TextInputAction.done,
                  ),
                  verticalSpacer(15),
                  Center(
                    child: Text(
                      controller.errMessage,
                      style: AppStyles.subStringStyle(13, AppColors.coolRed),
                    ),
                  ),
                  verticalSpacer(10),
                  controller.showLoading == true
                      ? loadingWidget()
                      : CustomButton(
                          width: screenWidth(context) * 0.5,
                          buttonText: "Book now",
                          onPressed: () {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            controller.attemptToCreateAppointment(
                              context,
                              _durationValue,
                              _roomSqFtValue,
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
