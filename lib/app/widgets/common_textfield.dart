import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/theme/colors.dart';
import '../utils/theme/fonts.dart';

Widget commonTextFieldView({
  TextEditingController? controller,
  String? hintText,
  String? labelText,
  String? counterText,
  String? validationMessage,
  double? horizontal,
  Widget? suffixIcon,
  Widget? prefixIcon,
  double? vertical,
  double? lcPadding,
  double? tcPadding,
  double? rcPadding,
  double? bcPadding,
  bool expands = false,
  Function()? onPressed,
  bool needValidation = false,
  bool readyOnly = false,
  bool hintTextBold = false,
  bool showBfBorder = true,
  Color? isFillColor,
  bool showBeBorder = true,
  bool titleTextBold = false,
  bool labelTextBold = false,
  bool fillColor = false,
  bool textAlign = false,
  bool showNumber = false,
  double? hintFontSize,
  double? labelFontSize,
  // double? textSize,
  Color? borderColor,
  Color? ebColor,
  Color? hintTextColor,
  Color? labelTextColor,
  Color? textColor,
  int? maxLength,
  int? maxLines,
  List<TextInputFormatter>? inputFormatters,
  TextInputType? keyBoardTypeEnter,
  bool obscureText = false,
  Function(String?)? onChangedValue,
  Function(String?)? onFieldSubmitted,
  TextInputAction? textInputAction,
  EdgeInsetsGeometry? margin,
  TextAlignVertical? textAlignVertical,
  FormFieldValidator<String>? validator,
  FocusNode? focusNode,
  bool autofocus = false,
}) {
  return Container(
    margin: margin,
    child: TextFormField(
      //  decoration: new InputDecoration(hintStyle: TextStyle(color: Colors.green)),
      focusNode: focusNode,
      autofocus: autofocus,
      onFieldSubmitted: onFieldSubmitted,
      textAlignVertical: textAlignVertical,
      expands: expands,
      onChanged: onChangedValue,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      keyboardType: keyBoardTypeEnter,
      textAlign: textAlign ? TextAlign.center : TextAlign.start,
      textInputAction: textInputAction ?? TextInputAction.done,
      style: TextStyle(
          fontFamily: Fonts.poppins,
          fontWeight: FontWeight.w400,
          fontSize: FontSizes.s16,
          color: MyColors.blackColor),
      maxLines: maxLines,
      cursorColor: MyColors.blackColor,
      decoration: InputDecoration(
        errorMaxLines: 2,
        contentPadding: EdgeInsets.only(
          left: lcPadding ?? 0,
          top: lcPadding ?? 0,
          right: rcPadding ?? 0,
          bottom: bcPadding ?? 0,
        ),
        fillColor: MyColors.whiteColor,
        focusedBorder: showBfBorder
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: MyColors.borderColor,
                ),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: MyColors.borderColor,
                ),
              ),
        enabledBorder: showBeBorder
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: MyColors.borderColor,
                ),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: MyColors.borderColor,
                ),
              ),
        counterText: counterText,
        filled: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: labelText,
        labelStyle: TextStyle(
            fontFamily: Fonts.poppins,
            fontWeight: FontWeight.w400,
            fontSize: FontSizes.s16,
            color: MyColors.borderColor),
        hintText: hintText,
        hintStyle: TextStyle(
            fontFamily: Fonts.poppins,
            fontWeight: FontWeight.w400,
            fontSize: FontSizes.s16,
            color: MyColors.borderColor),
        border: const OutlineInputBorder(),
      ),
      inputFormatters: inputFormatters ?? [],
      onTap: onPressed,
      maxLength: maxLength,
      readOnly: readyOnly,
      validator: needValidation ? validator : null,
    ),
  );
}
