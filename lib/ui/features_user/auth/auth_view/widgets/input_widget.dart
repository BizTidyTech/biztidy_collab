import 'package:biztidy_mobile_app/ui/features_user/auth/auth_controller/auth_controller.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_textfield_.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_theme_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget inputWidget({
  required String titleText,
  required TextEditingController textEditingController,
  required String hintText,
  TextInputAction? textInputAction = TextInputAction.next,
  TextInputType? keyboardType,
  bool? isObscurable,
  int? maxLines,
  int? minLines,
}) {
  final controller = Get.put(AuthController());

  return Builder(builder: (context) {
    return Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    height: 79,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: AppStyles.subStringStyle(12, context.textPrimary),
        ),
        CustomTextfield(
          textEditingController: textEditingController,
          hintText: hintText,
          textInputAction: textInputAction ?? TextInputAction.next,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          obscureText: isObscurable != true ? false : controller.isObscured,
          suffixIcon: isObscurable != true
              ? null
              : InkWell(
                  onTap: () {
                    controller.toggleObscurePassword();
                  },
                  child: Icon(
                    controller.isObscured
                        ? CupertinoIcons.eye_solid
                        : CupertinoIcons.eye_slash_fill,
                    size: 25,
                    color: AppColors.kPrimaryColor,
                  ),
                ),
        ),
      ],
    ),
    );
  });
}
