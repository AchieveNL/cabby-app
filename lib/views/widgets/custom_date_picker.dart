import 'package:cabby/config/theme.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePickerWidget extends StatefulWidget {
  final Function onData;
  const CustomDatePickerWidget({super.key, required this.onData});

  @override
  State<CustomDatePickerWidget> createState() => _CustomDatePickerWidgetState();
}

class _CustomDatePickerWidgetState extends State<CustomDatePickerWidget> {
  TextEditingController datePickerCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: datePickerCtrl,
      keyboardType: TextInputType.text,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 7000)),
          lastDate: DateTime.now().add(const Duration(days: 365 * 25)),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: AppColors.primaryColor,
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primaryColor,
                ),
                buttonTheme:
                    const ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          setState(() {
            datePickerCtrl.text = DateFormat('dd/MM/yyyy', 'nl_NL')
                .format(DateTime.parse(date.toIso8601String()))
                .toString();
          });
          widget.onData(datePickerCtrl.text);
        }
      },
      style: const TextStyle(color: AppColors.blackColor, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecorationWithSuffixIcon(
        label: '',
        fillColor: AppColors.greyColor,
        suffixIcon: GestureDetector(
          onTap: () {},
          child: const Icon(
            Icons.calendar_today_outlined,
            color: AppColors.blackColor,
            size: 18,
          ),
        ),
      ),
    );
  }
}
