import 'package:cabby/config/theme.dart';
import 'package:cabby/data/data.dart';
import 'package:cabby/models/signup.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileDetails extends StatefulWidget {
  final Function(SignupProfile) dataCallback;
  final Function({required String title, required bool isDisabled}) btnCallback;
  final SignupProfile profileData;

  const ProfileDetails({
    Key? key,
    required this.dataCallback,
    required this.btnCallback,
    required this.profileData,
  }) : super(key: key);

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController zipController;
  late TextEditingController streetController;
  late TextEditingController locationController;
  late TextEditingController dobController;

  String selectedCity = '';
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with data from widget.profileData
    nameController = TextEditingController(text: widget.profileData.name);
    phoneController = TextEditingController(text: widget.profileData.phone);
    zipController = TextEditingController(text: widget.profileData.zip);
    streetController = TextEditingController(text: widget.profileData.street);
    locationController =
        TextEditingController(text: widget.profileData.location);
    dobController = TextEditingController(
        text: widget.profileData.dob != null
            ? DateFormat('dd/MM/yyyy').format(widget.profileData.dob!)
            : '');

    selectedDate = widget.profileData.dob; // initialize date

    // Now add listeners
    nameController.addListener(validateForm);
    phoneController.addListener(validateForm);
    zipController.addListener(validateForm);
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
          buildLabel('Name'),
          buildSpace(),
          buildTextField(
            controller: nameController,
            keyboardType: TextInputType.text,
            label: 'Name',
          ),
          buildSpace(),
          buildLabel('Date of birth'),
          buildSpace(),
          buildDatePickerWidget(),
          buildSpace(),
          buildLabel('Phone Number'),
          buildSpace(),
          buildTextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            label: 'Phone (Optional)',
          ),
          buildSpace(),
          buildLabel('City/Region'),
          buildSpace(),
          buildTextField(
            controller: locationController,
            keyboardType: TextInputType.text,
            label: 'City/Region',
            onTap: _showModalCitySelector,
          ),
          buildSpace(),
          buildLabel('Zip Code'),
          buildSpace(),
          buildTextField(
            controller: zipController,
            keyboardType: TextInputType.number,
            label: 'Zip',
          ),
          buildSpace(),
          buildLabel('Street'),
          buildSpace(),
          buildTextField(
            controller: streetController,
            keyboardType: TextInputType.text,
            label: 'Street',
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
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                minimumDate: DateTime(1940),
                maximumDate: DateTime.now(),
                onDateTimeChanged: (DateTime dateTime) {
                  setState(() {
                    selectedDate = dateTime;
                    dobController.text =
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
            dobController.text =
                DateFormat('dd/MM/yyyy').format(date).toString();
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
                  itemCount: cities.length,
                  separatorBuilder: (context, i) {
                    return buildSpace();
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCity = cities[index];
                          locationController.text = cities[index];
                          validateForm();
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text(
                        cities[index],
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

  void validateForm() {
    if (selectedDate == null) {
      // Handle the error - maybe show a message asking the user to select a date
      return;
    }

    bool isFormValid = nameController.text.isNotEmpty &&
        zipController.text.isNotEmpty &&
        streetController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        dobController.text.isNotEmpty;

    widget.btnCallback(
      title: isFormValid ? 'NEXT' : 'ENTER DETAILS',
      isDisabled: !isFormValid,
    );

    SignupProfile data = SignupProfile()
      ..name = nameController.text
      ..dob = selectedDate
      ..phone = phoneController.text
      ..city = locationController.text
      ..zip = zipController.text
      ..street = streetController.text
      ..location = selectedCity;

    widget.dataCallback(data);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    zipController.dispose();
    streetController.dispose();
    locationController.dispose();
    dobController.dispose();
    super.dispose();
  }
}
