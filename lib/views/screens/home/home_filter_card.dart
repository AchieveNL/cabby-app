import 'package:cabby/config/theme.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/models/vehicle.dart';
import 'package:cabby/services/vehicle_service.dart';
import 'package:cabby/views/screens/vehicles_screens/vehicles_screen.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HomeFilterCard extends StatefulWidget {
  final bool isInScreen;
  const HomeFilterCard({
    super.key,
    required this.isInScreen,
  });

  @override
  _HomeFilterCardState createState() => _HomeFilterCardState();
}

class _HomeFilterCardState extends State<HomeFilterCard> {
  TextEditingController carSelectorController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController numberController = TextEditingController(text: '1');
  TextEditingController typeController = TextEditingController(text: 'Dag(en)');

  DateTime? selectedDate;

  List<AvailableVehicleModels> availableVehicles = [];

  @override
  void initState() {
    super.initState();
    fetchAvailableVehicles();
  }

  void fetchAvailableVehicles() async {
    try {
      availableVehicles = await VehicleService().getAvailableVehicles();
      setState(() {});
    } catch (e) {
      logger("Error fetching available vehicles: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Wil je een auto huren?',
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            buildTextField(
                controller: carSelectorController,
                keyboardType: TextInputType.text,
                label: "Alle auto's",
                onTap: _showModalCarSelector,
                prefixIcon: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SvgPicture.asset(
                    'assets/svg/car_icon.svg',
                    height: 18,
                    width: 16,
                  ),
                )),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: buildDatePickerWidget(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildTimePickerWidget(),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: buildNumberPickerWidget(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildTypePickerWidget(),
                ),
              ],
            ),
            const SizedBox(height: 15),
            if (!widget.isInScreen)
              PrimaryButton(
                btnText: 'Zoeken',
                radius: 10,
                width: screenSize.width * 0.95,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VehiclesScreen(),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String label,
    required Widget prefixIcon,
    Function()? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onTap: onTap,
      style: const TextStyle(color: AppColors.blackColor, fontSize: 16),
      decoration: DecorationInputs.textBoxInputDecorationWithPrefixWidget(
        label: label,
        prefix: prefixIcon,
      ),
    );
  }

  Widget buildDatePickerWidget() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day); // Today's date

    return TextFormField(
      controller: dateController,
      keyboardType: TextInputType.text,
      readOnly: true,
      onTap: () async {
        DateTime? date = await showModalBottomSheet<DateTime>(
          context: context,
          builder: (BuildContext builder) {
            return Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              color: Colors.white,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: today,
                minimumDate: today, // Set minimumDate to today
                maximumDate: today.add(
                    const Duration(days: 365)), // Optional: Set a maximum date
                onDateTimeChanged: (DateTime dateTime) {
                  setState(() {
                    selectedDate = dateTime;
                    dateController.text =
                        DateFormat('dd/MM/yyyy', 'nl_NL').format(dateTime);
                  });
                },
              ),
            );
          },
        );

        if (date != null) {
          setState(() {
            selectedDate = date;
            dateController.text =
                DateFormat('dd/MM/yyyy', 'nl_NL').format(date).toString();
          });
        }
      },
      style: const TextStyle(color: AppColors.blackColor, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecorationWithPrefixWidget(
          label: 'dd/mm/yyyy',
          prefix: FittedBox(
            fit: BoxFit.scaleDown,
            child: SvgPicture.asset(
              'assets/svg/calendar.svg',
              height: 24,
              width: 24,
            ),
          )),
    );
  }

  Widget buildTimePickerWidget() {
    return TextFormField(
      controller: timeController,
      keyboardType: TextInputType.text,
      readOnly: true,
      onTap: () async {
        TimeOfDay? time = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primaryColor,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: TimePickerDialog(
                cancelText: "Annuleren",
                helpText: "Selecteer tijd",
                confirmText: "Bevestigen",
                initialTime: TimeOfDay.now(),
              ),
            );
          },
        );

        if (time != null) {
          setState(() {
            timeController.text = time.format(context);
          });
        }
      },
      style: const TextStyle(color: AppColors.blackColor, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecorationWithPrefixWidget(
          label: 'Ophaaltijd',
          prefix: FittedBox(
            fit: BoxFit.scaleDown,
            child: SvgPicture.asset(
              'assets/svg/clock.svg',
              width: 24,
              height: 24,
            ),
          )),
    );
  }

  void _showModalCarSelector() {
    Size screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: screenSize.height * 0.3,
          alignment: Alignment.center,
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: availableVehicles.length,
                  separatorBuilder: (context, i) {
                    return buildSpace();
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          carSelectorController.text =
                              '${availableVehicles[index].companyName} ${availableVehicles[index].model}';
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text(
                        '${availableVehicles[index].companyName} ${availableVehicles[index].model}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildNumberPickerWidget() {
    if (numberController.text.isEmpty) {
      numberController.text = "1";
    }

    return TextFormField(
      controller: numberController,
      keyboardType: TextInputType.text,
      readOnly: true,
      onTap: () async {
        await showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext builder) {
            return SizedBox(
              height: 200,
              child: CupertinoPicker(
                itemExtent: 30.0,
                onSelectedItemChanged: (int value) {
                  setState(() {
                    numberController.text = (value + 1).toString();
                  });
                },
                children: List<Widget>.generate(30, (int index) {
                  // Generate numbers from 1 to 30
                  return Center(child: Text((index + 1).toString()));
                }),
              ),
            );
          },
        );
      },
      style: const TextStyle(color: AppColors.blackColor, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecorationWithPrefixWidget(
          label: 'Number',
          prefix: FittedBox(
            fit: BoxFit.scaleDown,
            child: SvgPicture.asset(
              'assets/svg/reset.svg',
              height: 24,
              width: 24,
            ),
          )),
    );
  }

  Widget buildTypePickerWidget() {
    return TextFormField(
      controller: typeController,
      keyboardType: TextInputType.text,
      readOnly: true,
      onTap: () async {
        await showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext builder) {
            return SizedBox(
              height: 200,
              child: CupertinoPicker(
                itemExtent: 30.0,
                onSelectedItemChanged: (int value) {
                  setState(() {
                    if (value == 0) {
                      typeController.text = "Dag(en)";
                    } else if (value == 1) {
                      typeController.text = "Week (weken)";
                    }
                  });
                },
                children: const <Widget>[
                  Center(child: Text("Dag(en)")),
                  Center(child: Text("Week (weken)")),
                ],
              ),
            );
          },
        );
      },
      style: const TextStyle(color: AppColors.blackColor, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecorationWithPrefixWidget(
          label: 'Type',
          prefix: FittedBox(
            fit: BoxFit.scaleDown,
            child: SvgPicture.asset(
              'assets/svg/Tune.svg',
              height: 24,
              width: 24,
            ),
          )),
    );
  }

  Widget buildSpace() {
    return const SizedBox(height: 10.0);
  }
}
