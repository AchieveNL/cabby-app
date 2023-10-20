import 'dart:io';

import 'package:cabby/config/theme.dart';
import 'package:cabby/views/screens/signup_screens/signup_screen.dart';
import 'package:cabby/views/widgets/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class PermitDetails extends StatefulWidget {
  final Function(SignupData) dataCallback; // Add this callback
  final Function({required String title, required bool isDisabled})
      btnCallback; // Add this callback

  const PermitDetails(
      {Key? key, required this.dataCallback, required this.btnCallback})
      : super(key: key);

  @override
  State<PermitDetails> createState() => _PermitDetailsState();
}

class _PermitDetailsState extends State<PermitDetails> {
  final ImagePicker _picker = ImagePicker();
  dynamic taxiPermitFile;

  void pickImage(ImageSource source) async {
    final XFile? res = await _picker.pickImage(source: source);
    if (res != null) {
      setState(() {
        taxiPermitFile = File(res.path);
      });
      // Call the validateForm function to update button and SignupData state
      validateForm();
    }
  }

  void onDataFromCustomDatePicker() {
    // Assuming the date picked from the CustomDatePickerWidget affects the form validity
    validateForm();
  }

  void validateForm() {
    bool isFormValid = taxiPermitFile != null;
    widget.btnCallback(title: "Next", isDisabled: !isFormValid);

    SignupData data = SignupData()..taxiPermitFile = taxiPermitFile;
    widget.dataCallback(data);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Form(
      child: Column(
        children: <Widget>[
          _buildHeaderRow("Taxi permission expire date"),
          const SizedBox(height: 10),
          CustomDatePickerWidget(onData: onDataFromCustomDatePicker),
          const SizedBox(height: 10),
          _buildHeaderRow("Taxi permission photo"),
          const SizedBox(height: 10),
          _buildImageInput(
              screenSize, taxiPermitFile, () => pickImage(ImageSource.camera)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  Row _buildHeaderRow(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xFF0A0A1C),
          ),
        ),
        const Text(" *",
            style: TextStyle(fontSize: 14, color: Color(0xFFD92037))),
      ],
    );
  }

  Widget _buildImageInput(Size screenSize, dynamic file, Function onTap) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF4F4F4),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      width: screenSize.width,
      height: screenSize.height / 3,
      child: file != null
          ? Image.file(file, fit: BoxFit.cover)
          : _buildImagePlaceholder(screenSize, onTap),
    );
  }

  Column _buildImagePlaceholder(Size screenSize, Function onTap) {
    return Column(
      children: [
        const Spacer(),
        SvgPicture.asset(
          "assets/Img_box_fill.svg",
          width: 48,
          height: 48,
          fit: BoxFit.contain,
        ),
        const Spacer(),
        SizedBox(
          width: screenSize.width * .8,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => onTap(),
                child: _buildTakeImageButton(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Container _buildTakeImageButton() {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Color(0xFFE8EBFF),
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/camera.svg'),
          const SizedBox(width: 10),
          const Text(
            'Take an image',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
