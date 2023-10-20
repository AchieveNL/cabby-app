import 'package:cabby/config/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static void showToast(
    BuildContext context,
    String msg,
  ) {
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: AppColors.blackColor,
        textColor: AppColors.whiteColor,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
  }

  static void showBlackToast(
    BuildContext context,
    String msg,
  ) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static void showToastCenter(
    BuildContext context,
    String msg,
  ) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
    );
  }
}
