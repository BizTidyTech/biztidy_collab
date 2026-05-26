import 'package:biztidy_mobile_app/ui/features_agent/agent_auth/agent_auth_controller/agent_auth_controller.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class AgentSignInView extends StatefulWidget {
  const AgentSignInView({super.key});

  @override
  State<AgentSignInView> createState() => _AgentSignInViewState();
}

class _AgentSignInViewState extends State<AgentSignInView> {
  final controller = Get.put(AgentAuthController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.plainWhite,
      ),
      child: GestureDetector(
        onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
        child: GetBuilder<AgentAuthController>(
          builder: (_) {
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryThemeColor,
                      AppColors.kPrimaryColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        verticalSpacer(60),
                        // Logo / Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.plainWhite,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.cleaning_services_rounded,
                            size: 44,
                            color: AppColors.primaryThemeColor,
                          ),
                        ),
                        verticalSpacer(16),
                        Text(
                          'BizTidy Agent',
                          style: AppStyles.keyStringStyle(
                              28, AppColors.plainWhite),
                        ),
                        verticalSpacer(6),
                        Text(
                          'Sign in to your agent account',
                          style: AppStyles.subStringStyle(
                              14, AppColors.plainWhite),
                        ),
                        verticalSpacer(48),

                        // Card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.plainWhite,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _inputLabel('Email Address'),
                              _inputField(
                                controller: controller.emailController,
                                hint: 'Enter your email',
                                keyboardType: TextInputType.emailAddress,
                              ),
                              verticalSpacer(16),
                              _inputLabel('Password'),
                              _passwordField(),
                              verticalSpacer(24),
                              if (controller.errMessage.isNotEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 12),
                                  child: Text(
                                    controller.errMessage,
                                    style: AppStyles.subStringStyle(
                                        13, AppColors.coolRed),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              controller.showLoading
                                  ? Center(child: loadingWidget())
                                  : CustomButton(
                                      buttonText: 'Sign In',
                                      width: screenWidth(context),
                                      onPressed: () {
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');
                                        controller.attemptSignIn(context);
                                      },
                                    ),
                            ],
                          ),
                        ),
                        verticalSpacer(40),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _inputLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: AppStyles.regularStringStyle(14, AppColors.fullBlack),
        ),
      );

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) =>
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              AppStyles.subStringStyle(14, AppColors.darkGray),
          filled: true,
          fillColor: AppColors.lighterGray,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      );

  Widget _passwordField() => GetBuilder<AgentAuthController>(
        builder: (c) => TextField(
          controller: c.passwordController,
          obscureText: c.isObscured,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: AppStyles.subStringStyle(14, AppColors.darkGray),
            filled: true,
            fillColor: AppColors.lighterGray,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: IconButton(
              icon: Icon(
                c.isObscured ? Icons.visibility_off : Icons.visibility,
                color: AppColors.darkGray,
              ),
              onPressed: c.toggleObscure,
            ),
          ),
        ),
      );
}
