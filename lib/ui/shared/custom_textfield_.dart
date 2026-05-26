// ignore_for_file: must_be_immutable

import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_theme_data.dart';
import 'package:flutter/material.dart';

TextStyle labelTextStyles = TextStyle(
  fontSize: 15,
  color: Colors.grey[500],
);

TextStyle hintTextStyles = const TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w300,
  color: Color.fromRGBO(153, 153, 153, 1),
);

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    super.key,
    this.fillColor,
    this.labelText,
    this.hintText,
    this.hintStyle,
    this.textEditingController,
    this.hasSuffixIcon = false,
    this.onSuffixIconPressed,
    this.suffixIcon,
    this.focusNode,
    this.initialValue,
    this.hasPrefixIcon = false,
    this.onPrefixIconPressed,
    this.keyboardType,
    this.prefixText,
    this.readOnly,
    this.prefixStyle,
    this.floatingLabelStyle,
    this.suffixIconSize,
    this.letterSpacing,
    this.obscureText,
    this.onChanged,
    this.maxLines,
    this.minLines,
    this.onTap,
    this.inputStringStyle,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization,
    this.contentpadding,
    this.scrollPadding,
    this.onSubmitted,
    this.autofocus,
    this.enabled = true,
    this.suffixText,
    this.textMaxLength,
  });

  final EdgeInsets? scrollPadding;
  final Color? fillColor;
  final String? labelText;
  final String? prefixText;
  final String? initialValue;
  final double? suffixIconSize;
  final double? letterSpacing;
  final String? suffixText;
  final String? hintText;
  final TextStyle? hintStyle;
  final bool? enabled;
  final bool? readOnly;
  final bool? autofocus;
  final int? maxLines;
  final int? minLines;
  final int? textMaxLength;
  final bool hasSuffixIcon;
  final bool hasPrefixIcon;
  final bool? obscureText;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final TextStyle? inputStringStyle;
  final TextStyle? prefixStyle;
  final TextStyle? floatingLabelStyle;
  final TextInputType? keyboardType;
  final TextEditingController? textEditingController;
  final TextInputAction textInputAction;
  final TextCapitalization? textCapitalization;
  final void Function()? onSuffixIconPressed;
  final void Function()? onPrefixIconPressed;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final EdgeInsetsGeometry? contentpadding;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: TextFormField(
        style: widget.inputStringStyle ??
            AppStyles.inputStringStyle(context.textPrimary),
        controller: widget.textEditingController,
        maxLength: widget.textMaxLength,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        obscureText: widget.obscureText ?? false,
        minLines: widget.minLines,
        maxLines: widget.obscureText == true ? 1 : widget.maxLines,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          fillColor: widget.fillColor ?? context.surfaceBg,
          filled: true,
          enabled: widget.enabled ?? true,
          suffixIcon: widget.suffixIcon,
          contentPadding: const EdgeInsets.fromLTRB(18, 0, 15, 0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(14.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: AppColors.primaryThemeColor, width: 1.5),
            borderRadius: BorderRadius.circular(14.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(14.0),
          ),
          labelStyle: labelTextStyles,
          hintStyle: widget.hintStyle ?? hintTextStyles,
          counterText: '',
        ),
      ),
    );
  }
}
