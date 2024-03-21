import 'package:cabby/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildDateTimePickerButton({
  required String title,
  required void Function()? onTap,
  DateTime? startDate,
  DateTime? endDate,
  Widget? textTitle,
  bool border = true,
}) {
  DateTime now = DateTime.now();
  String pickUpDate = DateFormat('d MMMM y', 'nl_NL').format(now);
  String dropOffDate =
      DateFormat('d MMMM y', 'nl_NL').format(now.add(const Duration(hours: 1)));
  String pickUpTime = DateFormat('hh:mm a', 'nl_NL').format(now);
  String dropOffTime =
      DateFormat('hh:mm a', 'nl_NL').format(now.add(const Duration(hours: 1)));

  if (startDate != null) {
    pickUpDate = DateFormat('d MMMM y', 'nl_NL').format(startDate);
    pickUpTime = DateFormat('hh:mm a', 'nl_NL').format(startDate);
  }
  if (endDate != null) {
    dropOffDate = DateFormat('d MMMM y', 'nl_NL').format(endDate);
    dropOffTime = DateFormat('hh:mm a', 'nl_NL').format(endDate);
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      textTitle ??
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      const SizedBox(height: 20),
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            border: border ? Border.all(color: Colors.grey.shade300) : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ophaaltijd'),
                  const SizedBox(height: 5),
                  Text(
                    pickUpDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(pickUpTime),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Inlevertijd'),
                  const SizedBox(height: 5),
                  Text(
                    dropOffDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(dropOffTime),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget buildDateTimePickerContent({
  DateTime? startDate,
  DateTime? endDate,
}) {
  DateTime now = DateTime.now();
  String pickUpDate = DateFormat('d MMMM y', 'nl_NL').format(now);
  String dropOffDate =
      DateFormat('d MMMM y', 'nl_NL').format(now.add(const Duration(days: 1)));
  String pickUpTime = DateFormat('hh:mm a', 'nl_NL').format(now);
  String dropOffTime =
      DateFormat('hh:mm a', 'nl_NL').format(now.add(const Duration(days: 1)));

  if (startDate != null) {
    pickUpDate = DateFormat('d MMMM y', 'nl_NL').format(startDate);
    pickUpTime = DateFormat('hh:mm a', 'nl_NL').format(startDate);
  }
  if (endDate != null) {
    dropOffDate = DateFormat('d MMMM y', 'nl_NL').format(endDate);
    dropOffTime = DateFormat('hh:mm a', 'nl_NL').format(endDate);
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ophaaltijd'),
                  const SizedBox(height: 5),
                  Text(
                    pickUpDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(pickUpTime),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Inlevertijd'),
                  const SizedBox(height: 5),
                  Text(
                    dropOffDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(dropOffTime),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
