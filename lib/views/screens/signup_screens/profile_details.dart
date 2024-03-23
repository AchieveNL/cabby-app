import 'dart:ffi';

import 'package:cabby/config/theme.dart';
import 'package:cabby/data/data.dart';
import 'package:cabby/models/signup.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ProfileDetails extends StatefulWidget {
  final Function(SignupProfile) dataCallback;
  final Function({required String title, required bool isDisabled}) btnCallback;
  final SignupProfile profileData;

  const ProfileDetails({
    super.key,
    required this.dataCallback,
    required this.btnCallback,
    required this.profileData,
  });

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController zipNumberController;
  late TextEditingController zipLetterController;
  late TextEditingController streetController;
  late TextEditingController locationController;
  late TextEditingController dobController;

  String selectedCity = '';
  DateTime? selectedDate;

  List<String> filteredCities = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with data from widget.profileData
    firstNameController =
        TextEditingController(text: widget.profileData.firstName);
    lastNameController =
        TextEditingController(text: widget.profileData.lastName);
    phoneController = TextEditingController(text: widget.profileData.phone);
    zipNumberController =
        TextEditingController(text: widget.profileData.zip?.substring(0, 4));
    zipLetterController =
        TextEditingController(text: widget.profileData.zip?.substring(4, 6));
    streetController = TextEditingController(text: widget.profileData.street);
    locationController =
        TextEditingController(text: widget.profileData.location);
    dobController = TextEditingController(
        text: widget.profileData.dob != null
            ? DateFormat('dd/MM/yyyy', 'nl_NL').format(widget.profileData.dob!)
            : '');

    selectedDate = widget.profileData.dob; // initialize date
    filteredCities = List.from(cities);

    // Now add listeners
    firstNameController.addListener(validateForm);
    phoneController.addListener(validateForm);
    zipNumberController.addListener(validateForm);
    zipLetterController.addListener(validateForm);
    streetController.addListener(validateForm);
    locationController.addListener(validateForm);
    dobController.addListener(validateForm);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSpace(),
          buildLabel('Voornaam'),
          buildSpace(),
          buildTextField(
            controller: firstNameController,
            keyboardType: TextInputType.text,
            label: 'Voornaam',
          ),
          buildLabel('Achternaam'),
          buildSpace(),
          buildTextField(
            controller: lastNameController,
            keyboardType: TextInputType.text,
            label: 'Achternaam',
          ),
          buildSpace(),
          buildLabel('Geboortedatum'),
          buildSpace(),
          buildDatePickerWidget(),
          buildSpace(),
          buildLabel('Telefoonnummer'),
          buildSpace(),
          buildTextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            label: 'Telefoon (optioneel)',
          ),
          buildSpace(),
          buildLabel('Stad/regio'),
          buildSpace(),
          buildTextField(
            controller: locationController,
            keyboardType: TextInputType.text,
            label: 'Stad/regio',
            onTap: _showModalCitySelector,
          ),
          buildSpace(),
          buildLabel('Postcode'),
          buildSpace(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.4,
                child: buildPostCode(
                  controller: zipNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  label: '0000',
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.4,
                child: buildPostCode(
                  controller: zipLetterController,
                  filter: FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  keyboardType: TextInputType.text,
                  maxLength: 2,
                  label: 'XX',
                ),
              ),
            ],
          ),
          buildSpace(),
          buildLabel('Straat'),
          buildSpace(),
          buildTextField(
            controller: streetController,
            keyboardType: TextInputType.text,
            label: 'Straat',
          ),
          buildSpace(height: 20),
          buildSpace(),
        ],
      ),
    );
  }

  Widget buildSpace({double height = 10}) => SizedBox(height: height);

  Widget buildLabel(String text) => Text(text);

  Widget buildTextField({
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String label,
    Function()? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onTap: onTap,
      style: const TextStyle(color: AppColors.blackColor, fontSize: 16),
      decoration: DecorationInputs.textBoxInputDecoration(label: label),
    );
  }

  Widget buildPostCode({
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String label,
    int? maxLength,
    TextInputFormatter? filter,
    Function()? onTap,
  }) {
    return TextFormField(
      controller: controller,
      inputFormatters: [
        filter ?? FilteringTextInputFormatter.digitsOnly,
      ],
      maxLength: maxLength,
      keyboardType: keyboardType,
      onTap: onTap,
      style: const TextStyle(color: AppColors.blackColor, fontSize: 16),
      decoration: DecorationInputs.textBoxInputDecoration(label: label),
    );
  }

  Widget buildDatePickerWidget() {
    return TextFormField(
      controller: dobController,
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
                dateOrder: DatePickerDateOrder.dmy,
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                minimumDate: DateTime(1940),
                maximumDate: DateTime.now(),
                onDateTimeChanged: (DateTime dateTime) {
                  setState(() {
                    selectedDate = dateTime;
                    dobController.text =
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
            dobController.text =
                DateFormat('dd/MM/yyyy', 'nl_NL').format(date).toString();
          });
        }
      },
      style: const TextStyle(color: AppColors.blackColor, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecorationWithSuffixIcon(
        label: 'dd/MM/yyyy',
        suffixIcon: const Icon(Icons.calendar_today_outlined,
            color: AppColors.blackColor, size: 18),
      ),
    );
  }

  void _showModalCitySelector() {
    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the modal full screen
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      builder: (context) {
        return StatefulBuilder(
          // Added StatefulBuilder for local state management
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: MediaQuery.of(context)
                  .viewInsets, // Adjusts padding for keyboard
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    TextField(
                      controller: searchController,
                      style: const TextStyle(
                          color: AppColors.primaryColor), // Text color
                      cursorColor: AppColors.primaryColor, // Cursor color
                      decoration: const InputDecoration(
                        labelText: 'Zoek naar jouw stad',
                        labelStyle: TextStyle(
                            color: AppColors.primaryColor), // Label text color
                        suffixIcon: Icon(Icons.search,
                            color: AppColors.primaryColor), // Icon color
                        // focusedBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //       color: AppColors.primaryColor, width: 1.0),
                        // ),
                        // enabledBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //       color: AppColors.primaryColor, width: 1.0),
                        // ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          // Filter cities as user types
                          if (value.isEmpty) {
                            filteredCities = cities;
                          } else {
                            filteredCities = cities
                                .where((city) => city
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: filteredCities
                            .length, // Use length of filteredCities
                        separatorBuilder: (context, i) {
                          return buildSpace();
                        },
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedCity = filteredCities[index];
                                locationController.text = filteredCities[index];
                                validateForm();
                                Navigator.of(context).pop();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(
                                  10), // Adjust padding as needed
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5), // Space between items

                              child: Text(
                                filteredCities[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void validateForm() {
    if (selectedDate == null) {
      // Handle the error - maybe show a message asking the user to select a date
      return;
    }

    bool isFormValid = firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        zipNumberController.text.isNotEmpty &&
        zipLetterController.text.isNotEmpty &&
        streetController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        dobController.text.isNotEmpty;

    widget.btnCallback(
      title: isFormValid ? 'VOLGENDE' : 'Voer gegevens in',
      isDisabled: !isFormValid,
    );

    SignupProfile data = SignupProfile()
      ..firstName = firstNameController.text
      ..lastName = lastNameController.text
      ..dob = selectedDate
      ..phone = phoneController.text
      ..city = locationController.text
      ..zip = zipNumberController.text + zipLetterController.text
      ..street = streetController.text
      ..location = selectedCity;

    widget.dataCallback(data);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    phoneController.dispose();
    zipNumberController.dispose();
    streetController.dispose();
    zipLetterController.dispose();
    locationController.dispose();
    dobController.dispose();
    super.dispose();
  }
}
