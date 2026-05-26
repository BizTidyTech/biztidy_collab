// ignore_for_file: must_be_immutable

import 'package:biztidy_mobile_app/ui/features_user/auth/auth_controller/auth_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_view/widgets/input_widget.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_views/web_data_view.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_theme_data.dart';
import 'package:biztidy_mobile_app/utils/app_constants/constants.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/string_cap_extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final controller = Get.put(AuthController());
  static const String nigeria = 'Nigeria', usa = 'USA';
  String _selectedCountry = nigeria;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            context.isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: context.bgColor,
      ),
      child: GestureDetector(
        onTap: () =>
            SystemChannels.textInput.invokeMethod('TextInput.hide'),
        child: GetBuilder<AuthController>(
          init: AuthController(),
          builder: (_) {
            return Scaffold(
              backgroundColor: context.bgColor,
              body: Column(
                children: [
                  // ── Top teal header ────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF00B4B4), Color(0xFF007A7A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        verticalSpacer(24),
                        Text(
                          'Create Account',
                          style: AppStyles.keyStringStyle(28, Colors.white),
                        ),
                        verticalSpacer(6),
                        Text(
                          'Join BizTidy and keep your space spotless',
                          style: AppStyles.subStringStyle(
                              15, Colors.white.withOpacity(0.85)),
                        ),
                      ],
                    ),
                  ),

                  // ── Form ──────────────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          inputWidget(
                            titleText: AppStrings.fullName.toSentenceCase,
                            textEditingController:
                                controller.fullnameController,
                            hintText: 'Enter your name',
                          ),
                          inputWidget(
                            titleText: AppStrings.email,
                            textEditingController:
                                controller.emailController,
                            hintText: 'Enter your email address',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          inputWidget(
                            titleText: AppStrings.password,
                            textEditingController:
                                controller.passwordController,
                            hintText: 'Enter your preferred password',
                            isObscurable: true,
                          ),
                          inputWidget(
                            titleText: AppStrings.confirmPassword,
                            textEditingController:
                                controller.confirmPasswordController,
                            hintText: 'Confirm your password',
                            textInputAction: TextInputAction.done,
                            isObscurable: true,
                          ),
                          verticalSpacer(14),
                          Text(
                            'Country',
                            style: AppStyles.subStringStyle(
                                13, context.textPrimary),
                          ),
                          verticalSpacer(8),
                          _countrySelector(context),
                          verticalSpacer(16),
                          if (controller.errMessage.isNotEmpty) ...[
                            Center(
                              child: Text(
                                controller.errMessage,
                                style: AppStyles.subStringStyle(
                                    13, AppColors.coolRed),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            verticalSpacer(10),
                          ],
                          controller.showLoading == true
                              ? const SizedBox.shrink()
                              : Center(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: 'By signing up, you accept the ',
                                      style: AppStyles.subStringStyle(
                                          13, context.textSecondary),
                                      children: [
                                        TextSpan(
                                          text: AppStrings.termsOfUse,
                                          style:
                                              AppStyles.regularStringStyle(
                                                  13,
                                                  AppColors
                                                      .primaryThemeColor),
                                          recognizer:
                                              TapGestureRecognizer()
                                                ..onTap = () {
                                                  goToWebViewPage(context,
                                                      title: AppStrings
                                                          .termsOfUse,
                                                      url: termsOfUseUrl);
                                                },
                                        ),
                                        TextSpan(
                                          text: ' and ',
                                          style: AppStyles.subStringStyle(
                                              13, context.textSecondary),
                                        ),
                                        TextSpan(
                                          text: AppStrings.privacyPolicy,
                                          style:
                                              AppStyles.regularStringStyle(
                                                  13,
                                                  AppColors
                                                      .primaryThemeColor),
                                          recognizer:
                                              TapGestureRecognizer()
                                                ..onTap = () {
                                                  goToWebViewPage(context,
                                                      title: AppStrings
                                                          .privacyPolicy,
                                                      url: privacyPolicyUrl);
                                                },
                                        ),
                                      ],
                                    ),
                                    textScaler:
                                        const TextScaler.linear(1),
                                  ),
                                ),
                          verticalSpacer(14),
                          controller.showLoading == true
                              ? loadingWidget()
                              : CustomButton(
                                  buttonText: AppStrings.signUp,
                                  onPressed: () {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                    controller.attemptToVerifyNewUser(
                                        context, _selectedCountry);
                                  },
                                ),
                          verticalSpacer(16),
                          controller.showLoading == true
                              ? const SizedBox.shrink()
                              : Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Already have an account? ',
                                      style: AppStyles.subStringStyle(
                                          14, context.textSecondary),
                                      children: [
                                        TextSpan(
                                          text: AppStrings.login,
                                          style:
                                              AppStyles.regularStringStyle(
                                                  14,
                                                  AppColors
                                                      .primaryThemeColor),
                                          recognizer:
                                              TapGestureRecognizer()
                                                ..onTap = () {
                                                  controller.resetValues();
                                                  context.pushReplacement(
                                                      '/signInUserView');
                                                },
                                        ),
                                      ],
                                    ),
                                    textScaler:
                                        const TextScaler.linear(1),
                                  ),
                                ),
                          verticalSpacer(32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _countrySelector(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _countryTile(context, nigeria, '🇳🇬'),
          Divider(height: 1, color: context.dividerColor),
          _countryTile(context, usa, '🇺🇸'),
        ],
      ),
    );
  }

  Widget _countryTile(BuildContext context, String country, String flag) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => setState(() => _selectedCountry = country),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                country,
                style:
                    AppStyles.normalStringStyle(15, context.textPrimary),
              ),
            ),
            Radio<String>(
              activeColor: AppColors.primaryThemeColor,
              value: country,
              groupValue: _selectedCountry,
              onChanged: (v) {
                if (v != null) setState(() => _selectedCountry = v);
              },
            ),
          ],
        ),
      ),
    );
  }
}
