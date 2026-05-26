// ignore_for_file: must_be_immutable

import 'package:biztidy_mobile_app/ui/features_user/auth/auth_controller/auth_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_view/widgets/input_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_theme_data.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SignInUserView extends StatelessWidget {
  SignInUserView({super.key});

  final controller = Get.put(AuthController());

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
        onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
        child: GetBuilder<AuthController>(
          init: AuthController(),
          builder: (_) {
            return Scaffold(
              backgroundColor: context.bgColor,
              body: Column(
                children: [
                  // ── Top teal header ──────────────────────────────────────
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
                          'Welcome Back 👋',
                          style: AppStyles.keyStringStyle(28, Colors.white),
                        ),
                        verticalSpacer(6),
                        Text(
                          'Sign in to continue to BizTidy',
                          style: AppStyles.subStringStyle(
                              15, Colors.white.withOpacity(0.85)),
                        ),
                      ],
                    ),
                  ),

                  // ── Form ────────────────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          inputWidget(
                            titleText: AppStrings.email,
                            textEditingController: controller.emailController,
                            hintText: 'Enter your email address',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          inputWidget(
                            titleText: AppStrings.password,
                            textEditingController:
                                controller.passwordController,
                            hintText: 'Enter your password',
                            isObscurable: true,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => context
                                  .push('/forgotPasswordEmailScreen'),
                              child: Text(
                                'Forgot Password?',
                                style: AppStyles.regularStringStyle(
                                    14, AppColors.primaryThemeColor),
                              ),
                            ),
                          ),
                          verticalSpacer(8),
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
                              ? loadingWidget()
                              : CustomButton(
                                  buttonText: AppStrings.login,
                                  onPressed: () {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                    controller
                                        .attemptToSignInUser(context);
                                  },
                                ),
                          verticalSpacer(24),
                          controller.showLoading == true
                              ? const SizedBox.shrink()
                              : Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Don't have an account? ",
                                      style: AppStyles.subStringStyle(
                                          14, context.textSecondary),
                                      children: [
                                        TextSpan(
                                          text: AppStrings.signUp,
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
                                                      '/createAccountView');
                                                },
                                        ),
                                      ],
                                    ),
                                    textScaler:
                                        const TextScaler.linear(1),
                                  ),
                                ),
                          verticalSpacer(24),
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
}
