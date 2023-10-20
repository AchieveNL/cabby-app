import 'package:cabby/config/theme.dart';
import 'package:cabby/data/data.dart';
import 'package:cabby/views/screens/signup_screens/signup_screen.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileDetails extends StatefulWidget {
  final Function(SignupData) dataCallback;
  final Function({required String title, required bool isDisabled}) btnCallback;
  const ProfileDetails({
    Key? key,
    required this.dataCallback,
    required this.btnCallback,
  }) : super(key: key);

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  String selectedCity = '';
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
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
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 7000)),
          lastDate: DateTime.now(),
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
            selectedDate = date;
            dobController.text = DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(date.toIso8601String()))
                .toString();
          });
        }
      },
      style: const TextStyle(color: AppColors.blackColor, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecorationWithSuffixIcon(
        label: '',
        fillColor: AppColors.greenColor,
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
                        });
                        Navigator.of(context).pop();
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
    bool isFormValid = nameController.text.isNotEmpty &&
        dobController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        zipController.text.isNotEmpty &&
        streetController.text.isNotEmpty;

    widget.btnCallback(title: "Next", isDisabled: !isFormValid);

    SignupData data = SignupData()
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
