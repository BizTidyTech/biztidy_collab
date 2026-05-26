// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_logger.i

import 'dart:io';

import 'package:biztidy_mobile_app/app/helpers/sharedprefs.dart';
import 'package:biztidy_mobile_app/app/services/firebase_service.dart';
import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_model/user_data_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_utils/auth_utils.dart';
import 'package:biztidy_mobile_app/ui/shared/globals.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/string_cap_extensions.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AuthController extends GetxController {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  UserData? userEnteredData;
  bool isResettingPassword = false;

  AuthController();

  bool showLoading = false, invalidOtp = false, isObscured = true;
  String errMessage = '';

  File? imageFile;

  disposeAllControllers() {
    fullnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();
    resetValues();
  }

  void resetValues() {
    errMessage = "";
    showLoading = false;
    invalidOtp = false;
    imageFile = null;
    userEnteredData = null;
    update();
  }

  startLoading() {
    showLoading = true;
    errMessage = '';
    update();
  }

  stopLoading() {
    showLoading = false;
    update();
  }

  updateVals() {
    update();
  }

  toggleObscurePassword() {
    isObscured = !isObscured;
    logger.i("Toggling to $isObscured");
    update();
  }

  Future<void> attemptToVerifyNewUser(
      BuildContext context, String selectedCountry) async {
    logger.i('attemptToVerifyNewUser . . .');

    if (fullnameController.text.trim().isEmpty == true ||
        emailController.text.trim().isEmpty == true ||
        passwordController.text.trim().isEmpty == true ||
        confirmPasswordController.text.trim().isEmpty == true) {
      errMessage = 'All fields must be filled accordingly';
      update();
    } else if (await validateEmail(emailController.text.trim()) == false) {
      errMessage = 'Enter a valid email address';
      update();
    } else if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      errMessage = "Passwords do not match";
      update();
    } else {
      userEnteredData = UserData(
        userId: generateRandomString(),
        email: emailController.text.trim(),
        name: fullnameController.text.trim(),
        password: passwordController.text.trim(),
        country: selectedCountry,
      );
      logger.i('Registering user . . . ${userEnteredData?.toJson()}');
      sendEmailOtp(context);
    }
  }

  resetUserPassword(
      BuildContext context,
      String email,
      String newPassword,
      ) async {
    startLoading();
    try {
      final userData = await FirebaseService().getUserDetails(email: email);
      if (userData == null) {
        stopLoading();
        return;
      }
      User? authUser = FirebaseAuth.instance.currentUser;
      await AuthUtil().signInUser(
        userData.email ?? '',
        userData.password ?? '',
      );
      await authUser?.updatePassword(newPassword);

      final updatedUserProfile = userData.copyWith(
        password: newPassword,
      );
      logger.f("updatedUserProfile: ${updatedUserProfile.toJson()}");
      final updated =
      await FirebaseService().updateUserProfile(updatedUserProfile);
      if (updated == true) {
        await saveUserDetailsLocally(updatedUserProfile);
        context.pop();
        context.pop();
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error resetting your password",
        backgroundColor: AppColors.coolRed,
      );
    }
    stopLoading();
  }

  Future<void> sendEmailOtp(
      BuildContext context, {
        bool? navigate,
        bool? isResetPassword,
      }) async {
    isResettingPassword = isResetPassword ?? false;
    startLoading();
    logger.i("Sending OTP . . .");
    final sendOtpResponse = await EmailOTP.sendOTP(email: emailController.text);
    if (sendOtpResponse == true) {
      logger.f("OTP sent successfully");
      navigate != false
          ? context.push('/verifyOtpScreen')
          : Fluttertoast.showToast(msg: "OTP has been resent");
    } else {
      logger.e("Error sending OTP");
      errMessage = 'Error sending OTP. Check email and try again';
    }
    stopLoading();
  }

  Future<void> verifyOtp(BuildContext context) async {
    startLoading();
    final verifyOtpResponse = EmailOTP.verifyOTP(otp: otpController.text);
    if (verifyOtpResponse == true) {
      Fluttertoast.showToast(msg: "Email verification successful");
      if (isResettingPassword == true) {
        context.pushReplacement('/resetPasswordScreen');
        isResettingPassword = false;
        stopLoading();
      } else {
        createNewUser(context);
      }
    } else {
      invalidOtp = true;
      errMessage = 'Error verifying OTP';
      Fluttertoast.showToast(msg: 'Error verifying OTP');
      stopLoading();
    }
    otpController.clear();
    update();
  }

  createNewUser(BuildContext context) async {
    final isAccountCreated = await AuthUtil().createAccount(
      userEnteredData?.email ?? '',
      userEnteredData?.password ?? '',
    );
    if (isAccountCreated == true) {
      final isUserRegistered = await AuthUtil().registerUser(userEnteredData);
      if (isUserRegistered == true) {
        logger.f('Account created successfully.');
        await signInUser(
          context,
          userEnteredData?.email ?? '',
          userEnteredData?.password ?? '',
        );
      } else {
        errMessage = 'Error creating user.';
        logger.w('Error creating user.');
        stopLoading();
      }
    } else {
      errMessage = 'Error creating account.';
      logger.w('Error creating account.');
      stopLoading();
    }
  }

  Future<void> attemptToSignInUser(BuildContext context) async {
    logger.i('attemptToSignInUser . . .');
    if (emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty) {
      signInUser(
        context,
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } else {
      errMessage = 'Both username and password are required';
      logger.i("Errormessage: $errMessage");
      stopLoading();
    }
  }

  Future<void> signInUser(BuildContext context, String email, String password,
      {bool? navigateToHome = true}) async {
    logger.i('signing in user . . .');
    startLoading();
    final isLoggedIn = await AuthUtil().signInUser(email, password);
    if (isLoggedIn == true && navigateToHome != false) {
      Globals.isLoggedIn = isLoggedIn;
      context.go('/homepageView');
    } else if (isLoggedIn == false && navigateToHome != false) {
      errMessage = 'Invalid email or password. Please try again.';
      logger.w('Sign in failed — invalid credentials.');
    }
    stopLoading();
  }
}