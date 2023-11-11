import 'package:cabby/config/theme.dart';
import 'package:cabby/data/data.dart';
import 'package:cabby/views/screens/vehicles_screens/vehicles_screen.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeFilterCard extends StatefulWidget {
  final bool isInScreen;
  const HomeFilterCard({super.key, required this.isInScreen});

  @override
  _HomeFilterCardState createState() => _HomeFilterCardState();
}

class _HomeFilterCardState extends State<HomeFilterCard> {
  TextEditingController carSelectorController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController numberController = TextEditingController(text: '1');
  TextEditingController typeController = TextEditingController(text: 'Days');

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Want to rent a car?',
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
              label: 'All cars',
              onTap: _showModalCarSelector,
              prefixIcon: const Icon(
                CupertinoIcons.car_fill,
              ),
            ),
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
                  flex: 2,
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
                btnText: 'Find a car',
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
    DateTime startOfDay =
        DateTime(now.year, now.month, now.day); // Start of the day

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
                initialDateTime: startOfDay, // Use startOfDay
                minimumDate: startOfDay,
                maximumDate: startOfDay.add(const Duration(days: 30)),
                onDateTimeChanged: (DateTime dateTime) {
                  setState(() {
                    selectedDate = dateTime;
                    dateController.text =
                        DateFormat('dd/MM/yyyy').format(dateTime);
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
                DateFormat('dd/MM/yyyy').format(date).toString();
          });
        }
      },
      style: const TextStyle(color: AppColors.blackColor, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecorationWithPrefixWidget(
        label: 'dd/mm/yyyy',
        prefix: const Icon(
          Icons.calendar_today_outlined,
        ),
      ),
    );
  }

  Widget buildTimePickerWidget() {
    return TextFormField(
      controller: timeController,
      keyboardType: TextInputType.text,
      readOnly: true,
      onTap: () async {
        TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time != null) {
          setState(() {
            timeController.text = time.format(context);
          });
        }
      },
      style: const TextStyle(color: AppColors.blackColor, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecorationWithPrefixWidget(
        label: 'Time',
        prefix: const Icon(
          CupertinoIcons.clock,
        ),
      ),
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
                  itemCount: vehicles.length, // Assuming you have a cars list
                  separatorBuilder: (context, i) {
                    return buildSpace();
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // You might need to update this logic based on your use case.
                          carSelectorController.text = vehicles[index];
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text(
                        vehicles[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.darkGreyColor,
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
        prefix: const Icon(Icons.restore),
      ),
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
                      typeController.text = "Days";
                    } else if (value == 1) {
                      typeController.text = "Weeks";
                    }
                  });
                },
                children: const <Widget>[
                  Center(child: Text("Days")),
                  Center(child: Text("Weeks")),
                ],
              ),
            );
          },
        );
      },
      style: const TextStyle(color: AppColors.blackColor, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecorationWithPrefixWidget(
        label: 'Type',
        prefix: const Icon(Icons.tune),
      ),
    );
  }

  Widget buildSpace() {
    return const SizedBox(height: 10.0);
  }
}
