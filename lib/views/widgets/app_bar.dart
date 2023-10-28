import 'package:cabby/config/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar buildAppBarWithBack({
  required BuildContext context,
  required String title,
}) {
  return AppBar(
    backgroundColor: AppColors.primaryLightColor,
    elevation: 0,
    title: Text(
      title,
      style: const TextStyle(
        color: AppColors.whiteColor,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(
        CupertinoIcons.back,
        color: AppColors.whiteColor,
      ),
      onPressed: () => Navigator.of(context).pop(),
    ),
  );
}

AppBar buildAppBarForPage({
  required BuildContext context,
  required String title,
}) {
  return AppBar(
    backgroundColor: AppColors.primaryLightColor,
    elevation: 0,
    title: Text(
      title,
      style: const TextStyle(
        color: AppColors.whiteColor,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    centerTitle: true,
  );
}
