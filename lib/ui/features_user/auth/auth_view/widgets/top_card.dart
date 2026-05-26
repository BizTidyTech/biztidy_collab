import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:flutter/material.dart';

Widget authScreensTopCard(BuildContext context, String headerText) {
  return Container(
    width: screenWidth(context),
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).viewPadding.top + 12,
      bottom: 16,
      left: 8,
      right: 20,
    ),
    decoration: BoxDecoration(
      color: AppColors.plainWhite,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.fullBlack,
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          headerText,
          style: AppStyles.keyStringStyle(22, AppColors.fullBlack),
        ),
      ],
    ),
  );
}
