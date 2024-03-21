import 'package:cabby/config/theme.dart';
import 'package:flutter/material.dart';

class DecorationBoxes {
  static BoxDecoration decorationBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.primaryLightColor, AppColors.primaryColor],
        stops: [-0.2469, 0.7485],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  static BoxDecoration decorationRoundBottomContainer() {
    return const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ));
  }

  static BoxDecoration decorationRoundWithRadius(
      {Color? color, double? radius}) {
    return BoxDecoration(
        color: color ?? Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 20.0)));
  }

  static BoxDecoration decorationBackgroundWithBottomRadius(
      {Color? color, double? radius}) {
    return BoxDecoration(
      color: color ?? AppColors.greyColor.withOpacity(0.15),
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(radius ?? 20.0),
        bottomLeft: Radius.circular(radius ?? 20.0),
      ),
      boxShadow: const [
        BoxShadow(
          color: Colors.grey, //.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 10,
          offset: Offset(1, 0), // changes position of shadow
        ),
      ],
    );
  }

  static BoxDecoration decorationBackgroundGreyWithRadius() {
    return BoxDecoration(
      color: AppColors.greyColor.withOpacity(0.18),
      borderRadius: const BorderRadius.all(Radius.circular(30.0)),
    );
  }

  static BoxDecoration decorationWithRadiusAll(Color color, {double? radius}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 20.0)),
    );
  }

  static BoxDecoration decorationWithRadiusAllAndBorderColor(
      Color color, Color borderColor,
      {double? radius}) {
    return BoxDecoration(
      color: color,
      border: Border.all(width: 1.00, color: borderColor),
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 10.0)),
    );
  }

  static BoxDecoration decorationSquareWithShadow() {
    return BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryColor.withOpacity(0.6),
          // spreadRadius: 5,
          // blurRadius: 12,
          // offset: Offset(0, 2), // changes position of shadow
        ),
      ],
    );
  }

  static BoxDecoration decorationSquareWithoutShadowWithNormalRadius() {
    return BoxDecoration(
      color: const Color(0xffFFFFFF),
      border: Border.all(
        width: 2.00,
        color: AppColors.primaryColor,
      ),
      borderRadius: BorderRadius.circular(15.00),
    );
  }

  static BoxDecoration decorationSquareWithShadowWithNormalRadius(
      {Color? color, double? radius}) {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 3,
          offset: const Offset(0, 0), // changes position of shadow
        ),
      ],
      color: color ?? const Color(0xffFFFFFF),
      border: Border.all(
        width: 1.00,
        color: const Color(0xffFFFFFF),
      ),
      borderRadius: BorderRadius.circular(radius ?? 20.00),
    );
  }

  static BoxDecoration decorationSquareWithShadowWithMinRadius() {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 3,
          offset: const Offset(0, 0), // changes position of shadow
        ),
      ],
      color: const Color(0xffFFFFFF),
      border: Border.all(
        width: 2.00,
        color: const Color(0xffFFFFFF),
      ),
      borderRadius: BorderRadius.circular(10.00),
    );
  }

  static BoxDecoration decorationWhiteAllBorder({double? radius}) {
    return BoxDecoration(
      color: AppColors.whiteColor,
      border: Border.all(
        width: 2.00,
        color: AppColors.whiteColor,
      ),
      borderRadius: BorderRadius.circular(radius ?? 15.00),
    );
  }

  static BoxDecoration decorationGreyAllBorder({double? radius}) {
    return BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(radius ?? 15.00),
    );
  }

  static BoxDecoration decorationTopBorder() {
    return BoxDecoration(
      border: Border.all(
        width: 1.00,
        color: AppColors.greyColor,
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
        bottomLeft: Radius.zero,
        bottomRight: Radius.zero,
      ),
    );
  }

  static BoxDecoration decorationBottomBorder() {
    return const BoxDecoration(
      border: Border(
        bottom: BorderSide(width: 1.0, color: AppColors.whiteColor),
      ),
    );
  }
}

class DecorationInputs {
  static InputDecoration textBoxInputDecoration(
      {String? label,
      Color fillColor = AppColors.greyColor,
      Widget? suffixIcon}) {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: fillColor,
      hintText: label,
      hintStyle: const TextStyle(
          fontFamily: 'Montserrat', color: AppColors.blackColor, fontSize: 14),
      contentPadding: const EdgeInsets.all(15),
      errorStyle: TextStyle(color: AppColors.redColor.withOpacity(0.6)),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5), borderSide: BorderSide.none),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      suffixIcon: suffixIcon,
    );
  }

  static InputDecoration textBoxInputDecorationWithPrefixWidget(
      {String? label,
      required Widget prefix,
      Color fillColor = AppColors.greyColor}) {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: fillColor,
      hintText: label,
      hintStyle: const TextStyle(
          fontFamily: 'Montserrat', color: AppColors.blackColor, fontSize: 14),
      contentPadding: const EdgeInsets.all(15),
      errorStyle: TextStyle(
        color: AppColors.redColor.withOpacity(0.6),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1.0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide.none,
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primaryColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      prefixIcon: prefix,
    );
  }

  static InputDecoration textBoxInputDecorationWithPrefixIcon(
      {String? label,
      required Icon prefixIcon,
      Color fillColor = AppColors.whiteColor}) {
    return InputDecoration(
        isDense: true,
        hintText: label ?? '',
        filled: true,
        fillColor: fillColor,
        errorStyle: TextStyle(color: AppColors.redColor.withOpacity(0.6)),
        hintStyle: const TextStyle(color: AppColors.blackColor, fontSize: 16),
        contentPadding: const EdgeInsets.all(15),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        prefixIcon: prefixIcon);
  }

  static InputDecoration textBoxInputDecorationWithPrefixAndSuffixIcon(
      {required String label, required Widget prefix, required Widget suffix}) {
    return InputDecoration(
        border: InputBorder.none,
        labelText: label,
        contentPadding: const EdgeInsets.all(10.0),
        labelStyle: const TextStyle(
          color: Colors.grey,
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        prefixIcon: prefix,
        suffixIcon: suffix);
  }

  static InputDecoration textBoxInputDecorationWithSuffixIcon(
      {required String label,
      required Widget suffixIcon,
      double minWidth = 30,
      Color fillColor = AppColors.greyColor}) {
    return InputDecoration(
      //border: InputBorder.none,
      errorMaxLines: 2,
      filled: true,
      isDense: true,
      fillColor: fillColor,
      hintText: label,
      errorStyle: TextStyle(color: AppColors.redColor.withOpacity(0.6)),
      hintStyle: const TextStyle(
          fontFamily: 'Montserrat', color: AppColors.blackColor, fontSize: 13),
      suffixIcon: suffixIcon,
      suffixIconConstraints: BoxConstraints(minWidth: minWidth),
      contentPadding: const EdgeInsets.all(15),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5), borderSide: BorderSide.none),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
  }
}
