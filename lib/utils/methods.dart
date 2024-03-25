import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cabby/config/theme.dart';
import 'package:cabby/views/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

getWeekdayName(weekday) {
  const Map<int, String> weekdayName = {
    1: "Mon",
    2: "Tue",
    3: "Wed",
    4: "Thu",
    5: "Fri",
    6: "Sat",
    7: "Sun"
  };
  return weekdayName[weekday];
}

getMonthName(month) {
  const Map<int, String> monthName = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December"
  };
  return monthName[month];
}

getLabel(String label,
    {double padding = 0, Color color = AppColors.blackColor}) {
  return Padding(
    padding: EdgeInsets.only(left: padding),
    child: Text(
      label,
      style: TextStyle(
        fontFamily: "SF Cartoonist Hand",
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    ),
  );
}

String getRandomString(int length) {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();

  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

String twoDigits(int n) {
  if (n >= 10) return '$n';
  return '0$n';
}

String formatBySeconds(Duration duration) =>
    twoDigits(duration.inSeconds.remainder(60));

String formatByMinutes(Duration duration) {
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  return '$twoDigitMinutes:${formatBySeconds(duration)}';
}

String formatByHours(Duration duration) {
  return '${twoDigits(duration.inHours)}:${formatByMinutes(duration)}';
}

String? requiredValidation(String? value) {
  if (value!.isEmpty) {
    return '*Required';
  }
  if (value.length < 3) {
    return 'Must be at least 3 characters';
  }
  return null;
}

String? zipValidation(String? value) {
  if (value!.isEmpty) {
    return '*Required';
  }

  if (value.length < 4) return "";

  if (!RegExp(r'^\d{4}$').hasMatch(value.substring(0, 4))) {
    return "First four characters should be numbers";
  }

  if (value.length < 6) return "";

  // Check the last 2 characters are letters
  if (!RegExp(r'^[a-zA-Z]{2}$').hasMatch(value.substring(4))) {
    return "Last two characters should be letter";
  }

  return null;
}

String? bsnValidation(String? value) {
  if (value!.isEmpty) {
    return '*Required';
  }

  if (value.length < 9) {
    return 'Must be at least 9 characters';
  }

  if (value.length > 9) {
    return 'Must be equal to 9 characters';
  }

  return null;
}

String? requiredOTPValidation(String? value) {
  if (value!.isEmpty) {
    return '*Required';
  }
  if (value.length < 4) {
    return '*Must be at least 4 characters';
  }
  return null;
}

String? requiredCheck(String? value) {
  if (value!.isEmpty) {
    return '*Required';
  }
  return null;
}

String? validateMobileNumberLength(String? value) {
  if (value!.length != 11) {
    return 'Phone Number must be of 11 digit';
  }
  return null;
}

String? validatePasswordLength(String? value) {
  if (value!.length < 8) {
    return 'Minimum length must be 8 characters';
  }
  return null;
}

String? validatePassword(String? value) {
  RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  if (value!.length < 8) {
    return 'Voer minimaal 8 tekens in.';
  }
  if (!passValid.hasMatch(value)) {
    return "Password should contain Capital letter, Small letter, Number & Special character";
  }
  return null;
}

String? validateCount(String? value) {
  if (value!.isEmpty) {
    return '*Required';
  } else if (value.isNotEmpty && int.parse(value) >= 20) {
    return 'Children should be less than or equal to 20';
  }
  return null;
}

String? validateAge(String? value) {
  if (value!.isEmpty) {
    return '*Required';
  } else if (value.isNotEmpty && int.parse(value) >= 20) {
    return 'Age should be less than or equal to 12';
  }
  return null;
}

String? validateConfirmPassword(String? confirmPassword, String? password) {
  if (confirmPassword != password) {
    return 'Confirm Password must be same as Password';
  }
  return null;
}

String? validateEmail(String? value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value!)) {
    return 'Voer een geldig e-mailadres in.';
  }
  return null;
}

getInitials(String name) {
  List<String> nameParts = name.split(' ');
  String initials = '';
  for (var part in nameParts) {
    initials += part[0];
  }
  return initials.toUpperCase();
}

getFileBase64(path) {
  File image = File(path);
  return base64Encode(image.readAsBytesSync());
}

String getDateFormattedAsDDMMYYYYHHMM(DateTime date) {
  return DateFormat('d MMM yyyy - hh:mm a', 'nl_NL').format(date).toString();
}

String getDateFormattedAsHHMM(DateTime date) {
  return DateFormat('hh:mm a', 'nl_NL').format(date).toString();
}

String getDate(DateTime date) {
  return DateFormat('d', 'nl_NL').format(date).toString();
}

String getDateMonth(DateTime date) {
  return DateFormat('d/MM', 'nl_NL').format(date).toString();
}

String getDateFormattedAsYYYYMMMD(DateTime date) {
  return DateFormat('yyyy MMM d', 'nl_NL').format(date).toString();
}

String getDateFormattedAsDDMMYYYY(DateTime date) {
  return DateFormat('d/MM/yyyy', 'nl_NL').format(date).toString();
}

String getDateFormattedAsDayMonDate(DateTime date) {
  return DateFormat('E MMM d, yyyy', 'nl_NL').format(date).toString();
}

String getDateFormatted(DateTime date) {
  return DateFormat('MMM d', 'nl_NL').format(date).toString();
}

String getCurrentDate() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd', 'nl_NL');
  return formatter.format(now);
}

String priceFormatter(int amount) {
  var format = NumberFormat("#,###", 'nl_NL');
  return format.format(amount);
}

launchUrlV2(url, BuildContext context) async {
  if (await canLaunch(url)) {
    await launch(
      url,
    );
  } else {
    ToastUtil.showToast(context, 'Invalid Url');
    throw 'Could not launch $url';
  }
}

setImage(image) {
  return image == "" || image == null || image == "null"
      ? const AssetImage('assets/images/avatar.png')
      : MemoryImage(base64Decode(image));
}

Future<bool> getPermission(BuildContext context, perm) async {
  Permission permission = Permission.byValue(perm);
  PermissionStatus pStatus = await permission.request();
  return statusPermission(context, pStatus, permission);
}

Future<bool> getPermissions(BuildContext context, Permission perm) async {
  Permission permission = Permission.byValue(perm.value);
  PermissionStatus pStatus = await permission.request();
  return statusPermission(context, pStatus, permission);
}

Future<bool> statusPermission(
    BuildContext context, perStatus, Permission permissionObj) async {
  if (perStatus == PermissionStatus.granted) {
    return true;
  } else if (perStatus == PermissionStatus.limited) {
    PermissionStatus status = await permissionObj.request();
    return statusPermission(context, status, permissionObj);
  } else if (perStatus == PermissionStatus.denied) {
    PermissionStatus status = await permissionObj.request();
    return statusPermission(context, status, permissionObj);
  } else if (perStatus == PermissionStatus.restricted) {
    return false;
    // showAlert(context, "Open settings to enable permissions");
  } else if (perStatus == PermissionStatus.permanentlyDenied) {
    // showAlert(context, "Open settings to enable permissions");
    return false;
  } else {
    // showAlert(context, "Open settings to enable permissions");
    return false;
  }
}
