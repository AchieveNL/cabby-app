import 'package:cabby/config/theme.dart';
import 'package:flutter/material.dart';

class CustomDateRangePicker {
  static Future<DateTimeRange?> showCustomDateRangePicker({
    required BuildContext context,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTimeRange? initialDateRange,
  }) async {
    DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: initialDateRange,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primaryLightColor,
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryLightColor,
            ),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    return pickedDateRange;
  }
}
