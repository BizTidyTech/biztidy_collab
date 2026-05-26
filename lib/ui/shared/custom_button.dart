import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final Color? color;
  final Color? borderColor;
  final double? borderRadius;
  final String? buttonText;
  final double? fontSize;
  final Color? textcolor;
  final bool outlined;
  final void Function()? onPressed;

  const CustomButton({
    super.key,
    this.width,
    this.height,
    this.child,
    this.color,
    this.onPressed,
    this.borderRadius,
    this.borderColor,
    this.buttonText,
    this.fontSize,
    this.textcolor,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final double btnWidth = width ?? screenWidth(context) * 0.88;
    final double btnHeight = height ?? 54;
    final double radius = borderRadius ?? 30;

    if (outlined) {
      return SizedBox(
        width: btnWidth,
        height: btnHeight,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: borderColor ?? AppColors.deepBlue,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: child ??
              Text(
                buttonText ?? '',
                style: AppStyles.regularStringStyle(
                  fontSize ?? 16,
                  textcolor ?? AppColors.deepBlue,
                ),
              ),
        ),
      );
    }

    return Container(
      width: btnWidth,
      height: btnHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color ?? AppColors.deepBlue,
        boxShadow: [
          BoxShadow(
            color: (color ?? AppColors.deepBlue).withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(radius),
          child: Center(
            child: child ??
                Text(
                  buttonText ?? '',
                  style: AppStyles.regularStringStyle(
                    fontSize ?? 16,
                    textcolor ?? AppColors.kPrimaryColor,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
