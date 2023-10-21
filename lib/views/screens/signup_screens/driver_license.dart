// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cabby/config/theme.dart';
import 'package:cabby/models/signup.dart';
import 'package:cabby/views/screens/signup_screens/camera_access_screen.dart';
import 'package:cabby/views/screens/signup_screens/camera_screen.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class DriverLicenceScreen extends StatefulWidget {
  final Function(SignupDriverLicence) dataCallback;
  final Function btnCallback;

  final SignupDriverLicence driverLicenceData;
  const DriverLicenceScreen({
    Key? key,
    required this.dataCallback,
    required this.btnCallback,
    required this.driverLicenceData,
  }) : super(key: key);


  @override
  State<DriverLicenceScreen> createState() => _DriverLicenceScreenState();
}

class _DriverLicenceScreenState extends State<DriverLicenceScreen> {
  File? driverLicenseFront;
  File? driverLicenseBack;
  String? expiryDate;
  final TextEditingController expiryDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    driverLicenseFront = widget.driverLicenceData.driverLicenseFront;
    driverLicenseBack = widget.driverLicenceData.driverLicenseBack;
    expiryDate = widget.driverLicenceData.expiryDate;
    if (expiryDate != null) {
      expiryDateController.text = expiryDate!;
    }
  }

  Future<void> pickImage(String licenseSide) async {
    bool inDebugMode = false;
    assert(() {
      inDebugMode = true;
      return true;
    }());

    if (inDebugMode) {
      String url = licenseSide == 'front'
          ? 'https://storage.googleapis.com/cabby-bucket/images/front.png'
          : 'https://storage.googleapis.com/cabby-bucket/images/back.png';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        String tempPath = (await getTemporaryDirectory()).path;
        File tempFile = File('$tempPath/$licenseSide.png')
          ..writeAsBytesSync(bytes);

        setState(() {
          if (licenseSide == 'front') {
            driverLicenseFront = tempFile;
          } else {
            driverLicenseBack = tempFile;
          }
        });

        updateParentWidget();
      } else {
        throw Exception('Failed to load image.');
      }
    } else {
      final status = await Permission.camera.status;

      if (status.isGranted) {
        _navigateToCameraScreen(licenseSide);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraAccessScreen(
              onCameraAccessGranted: () {
                _navigateToCameraScreen(licenseSide);
              },
            ),
          ),
        );
      }
    }
  }

  void _navigateToCameraScreen(String licenseSide) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          onImageCaptured: (file) {
            setState(() {
              if (licenseSide == 'front') {
                driverLicenseFront = file;
              } else {
                driverLicenseBack = file;
              }
            });
            updateParentWidget();
          },
          name: "Driver's License $licenseSide side",
        ),
      ),
    );
  }


  void updateParentWidget() {
    final isDisabled = driverLicenseFront == null ||
        driverLicenseBack == null ||
        (expiryDate == null || expiryDate!.isEmpty);

    widget.dataCallback(SignupDriverLicence()
      ..driverLicenseFront = driverLicenseFront
      ..driverLicenseBack = driverLicenseBack
      ..expiryDate = expiryDate);

    widget.btnCallback(
      title: isDisabled ? 'Next' : 'Submit',
      isDisabled: isDisabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          ..._buildSection(
              "Driver's License expire date", buildDatePickerWidget()),
          ..._buildSection("Driver's License photo (front side)",
              _buildLicenseContainer(driverLicenseFront, 'front')),
          ..._buildSection("Driver's License photo (Back side)",
              _buildLicenseContainer(driverLicenseBack, 'back')),
        ],
      ),
    );
  }

  List<Widget> _buildSection(String title, Widget content) {
    Size screenSize = MediaQuery.of(context).size;
    return [
      _buildHeader(title),
      SizedBox(height: screenSize.height * 0.02),
      content,
      SizedBox(height: screenSize.height * 0.02),
    ];
  }

  Widget _buildHeader(String title) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF0A0A1C))),
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
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          width: screenSize.width * 0.9,
          height: screenSize.width * 0.6,
          child: licenseFile != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(licenseFile, fit: BoxFit.contain),
                )
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
        SvgPicture.asset("assets/Img_box_fill.svg",
            width: 48, height: 48, fit: BoxFit.contain),
        const Spacer(),
        SizedBox(
          width: screenSize.width * .8,
          child: GestureDetector(
            onTap: () => pickImage(licenseSide),
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFE8EBFF),
              ),
              child: Row(
                children: [
                  SvgPicture.asset('assets/camera.svg'),
                  const SizedBox(width: 10),
                  const Text('Take an image',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                      textAlign: TextAlign.center)
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildDatePickerWidget() {
    return TextFormField(
      controller: expiryDateController,
      keyboardType: TextInputType.text,
      readOnly: true,
      onTap: () async {
        await showModalBottomSheet(
          context: context,
          builder: (BuildContext builder) {
            return Container(
              height: MediaQuery.of(context).size.height / 3,
              color: Colors.white,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                minimumDate: DateTime.now().subtract(const Duration(days: 3650)),
                maximumDate: DateTime.now().add(const Duration(days: 3650)),
                onDateTimeChanged: (DateTime dateTime) {
                  expiryDate = DateFormat('dd/MM/yyyy').format(dateTime);
                  expiryDateController.text = expiryDate!;
                  updateParentWidget();
                },
              ),
            );
          },
        );
      },
      style: const TextStyle(color: AppColors.blackColor, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecorationWithSuffixIcon(
        label: 'Expiry Date (dd/MM/yyyy)',
        suffixIcon: const Icon(Icons.calendar_today_outlined,
            color: AppColors.blackColor, size: 18),
      ),
    );
  }
}
