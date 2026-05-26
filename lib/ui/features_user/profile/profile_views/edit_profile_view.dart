// ignore_for_file: prefer_const_constructors, must_be_immutable, unused_element

import 'package:biztidy_mobile_app/ui/features_user/profile/profile_controller/profile_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_views/widgets/profile_input_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_theme_data.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/string_cap_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final controller = Get.put(ProfileController());
  static const String nigeria = "Nigeria";
  String _selectedCountry = nigeria;

  @override
  void initState() {
    super.initState();
    controller.emailController =
        TextEditingController(text: controller.myProfileData?.email);
    controller.fullnameController =
        TextEditingController(text: controller.myProfileData?.name);
    controller.phoneController =
        TextEditingController(text: controller.myProfileData?.phoneNumber);
    controller.addressController =
        TextEditingController(text: controller.myProfileData?.address);
    _selectedCountry = controller.myProfileData?.country ?? nigeria;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (_) {
        return GestureDetector(
          onTap: () =>
              SystemChannels.textInput.invokeMethod('TextInput.hide'),
          child: Scaffold(
            backgroundColor: context.bgColor,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              shadowColor: Colors.transparent,
              surfaceTintColor: context.cardBg,
              backgroundColor: context.cardBg,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.surfaceBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: context.textPrimary,
                    size: 18,
                  ),
                ),
              ),
              title: Text(
                AppStrings.editProfile,
                style: AppStyles.keyStringStyle(20, context.textPrimary),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  verticalSpacer(24),
                  // Avatar placeholder with edit icon
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryThemeColor.withOpacity(0.15),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: controller.myProfileData?.photoUrl != null
                              ? Image.network(
                                  controller.myProfileData!.photoUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                      Icons.person_rounded,
                                      size: 50,
                                      color: AppColors.primaryThemeColor),
                                )
                              : Icon(
                                  Icons.person_rounded,
                                  size: 50,
                                  color: AppColors.primaryThemeColor,
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primaryThemeColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: context.cardBg, width: 2),
                            ),
                            child: Icon(
                              Icons.edit_rounded,
                              size: 14,
                              color: AppColors.plainWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSpacer(28),
                  // Form fields
                  _formCard(
                    children: [
                      profileInputWidget(
                        titleText: AppStrings.fullName.toSentenceCase,
                        textEditingController: controller.fullnameController,
                        hintText: 'Enter your name',
                      ),
                      profileInputWidget(
                        titleText: AppStrings.email,
                        textEditingController: controller.emailController,
                        hintText: 'Enter your email address',
                        keyboardType: TextInputType.emailAddress,
                        enabled: false,
                      ),
                      profileInputWidget(
                        titleText: "Phone number",
                        textEditingController: controller.phoneController,
                        hintText: 'Enter your phone number',
                      ),
                      profileInputWidget(
                        titleText: "Address",
                        textEditingController: controller.addressController,
                        hintText: 'Enter your address',
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                  verticalSpacer(16),
                  if (controller.errMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        controller.errMessage,
                        style: AppStyles.subStringStyle(13, AppColors.coolRed),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  controller.showLoading == true
                      ? loadingWidget()
                      : CustomButton(
                          buttonText: AppStrings.update,
                          onPressed: () {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            controller.attemptToUpdateProfileData(
                                _selectedCountry);
                          },
                        ),
                  verticalSpacer(24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _formCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}
