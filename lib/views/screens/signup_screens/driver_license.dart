import 'dart:io';
import 'package:cabby/config/theme.dart';
import 'package:cabby/views/screens/signup_screens/signup_screen.dart';
import 'package:cabby/views/widgets/custom_date_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class DriverLicenceScreen extends StatefulWidget {
  final Function(SignupData) dataCallback;
  final Function btnCallback;

  const DriverLicenceScreen(
      {Key? key, required this.dataCallback, required this.btnCallback})
      : super(key: key);

  @override
  State<DriverLicenceScreen> createState() => _DriverLicenceScreenState();
}

class _DriverLicenceScreenState extends State<DriverLicenceScreen> {
  File? driverLicenseFront;
  File? driverLicenseBack;
  String? expiryDate;
  final ImagePicker _picker = ImagePicker();

  void onDataFromCustomDatePicker(String data) {
    expiryDate = data;
    if (kDebugMode) {
      print(data);
    }
    updateParentWidget();
  }

  Future<void> pickImage(String licenseSide, ImageSource source) async {
    final XFile? res = await _picker.pickImage(source: source);
    if (res != null) {
      setState(() {
        if (licenseSide == 'front') {
          driverLicenseFront = File(res.path);
        } else {
          driverLicenseBack = File(res.path);
        }
      });
      updateParentWidget();
    }
  }

  void updateParentWidget() {
    bool isDisabled = driverLicenseFront == null ||
        driverLicenseBack == null ||
        expiryDate == null;

    widget.dataCallback(SignupData()
      ..driverLicenseFront = driverLicenseFront
      ..driverLicenseBack = driverLicenseBack);

    widget.btnCallback(
      title: isDisabled
          ? 'Next'
          : 'Submit', // Or whatever logic you want for the button title
      isDisabled: isDisabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          _buildHeader("Driver's License expire date"),
          const SizedBox(height: 10),
          CustomDatePickerWidget(onData: onDataFromCustomDatePicker),
          _buildHeader("Driver's License photo (front side)"),
          _buildLicenseContainer(driverLicenseFront, 'front'),
          _buildHeader("Driver's License photo (Back side)"),
          _buildLicenseContainer(driverLicenseBack, 'back'),
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
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
        const Text("*",
            style: TextStyle(fontSize: 14, color: Color(0xFFD92037))),
      ],
    );
  }

  Widget _buildLicenseContainer(File? licenseFile, String licenseSide) {
    Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF4F4F4),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          width: screenSize.width,
          height: screenSize.height / 3,
          child: licenseFile != null
              ? Image.file(licenseFile, fit: BoxFit.cover)
              : _buildPlaceHolder(licenseSide),
        ),
      ],
    );
  }

  Widget _buildPlaceHolder(String licenseSide) {
    Size screenSize = MediaQuery.of(context).size;
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
          child: GestureDetector(
            onTap: () => pickImage(licenseSide, ImageSource.camera),
            child: Container(
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
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
