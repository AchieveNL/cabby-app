// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cabby/config/theme.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/models/signup.dart';
import 'package:cabby/views/screens/signup_screens/camera_access_screen.dart';
import 'package:cabby/views/screens/signup_screens/camera_screen.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DriverLicenceScreen extends StatefulWidget {
  final Function(SignupDriverLicence) dataCallback;
  final Function btnCallback;

  final SignupDriverLicence driverLicenceData;
  const DriverLicenceScreen({
    super.key,
    required this.dataCallback,
    required this.btnCallback,
    required this.driverLicenceData,
  });

  @override
  State<DriverLicenceScreen> createState() => _DriverLicenceScreenState();
}

class _DriverLicenceScreenState extends State<DriverLicenceScreen> {
  File? driverLicenseFront;
  File? driverLicenseBack;
  String? expiryDate;
  String? bsnNumber;
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController bsnNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    driverLicenseFront = widget.driverLicenceData.driverLicenseFront;
    driverLicenseBack = widget.driverLicenceData.driverLicenseBack;
    expiryDate = widget.driverLicenceData.expiryDate;
    bsnNumber = widget.driverLicenceData.bsnNumber;
    if (expiryDate != null) {
      expiryDateController.text = expiryDate!;
      bsnNumberController.text = bsnNumber!;
    }

    bsnNumberController.addListener(() {
      bsnNumber = bsnNumberController.text;
      updateParentWidget();
    });
  }

  Future<void> _downloadImage(String url, String licenseSide) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        File file = File('$tempPath/$licenseSide.png');
        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          if (licenseSide == 'front') {
            driverLicenseFront = file;
          } else if (licenseSide == 'back') {
            driverLicenseBack = file;
          }
        });
      } else {
        print('Failed to download the image');
      }
    } catch (e) {
      print('Error occurred while downloading the image: $e');
    }
  }

  Future<void> pickImage(String licenseSide) async {
    // if (kDebugMode) {
    //   if (licenseSide == 'front') {
    //     _downloadImage(
    //         'https://storage.googleapis.com/cabby-bucket/images/front.png',
    //         'front');
    //   } else {
    //     _downloadImage(
    //         'https://storage.googleapis.com/cabby-bucket/images/back.png',
    //         'back');
    //   }
    //   updateParentWidget();
    //   return;
    // }

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
        (expiryDate == null || expiryDate!.isEmpty) ||
        (bsnNumber == null || bsnNumber!.isEmpty);

    widget.dataCallback(SignupDriverLicence()
      ..driverLicenseFront = driverLicenseFront
      ..driverLicenseBack = driverLicenseBack
      ..expiryDate = expiryDate
      ..bsnNumber = bsnNumber);

    logger({expiryDate, driverLicenseBack, driverLicenseFront, bsnNumber});

    logger(isDisabled);

    widget.btnCallback(
      title: isDisabled ? 'Volgende' : 'Indienen',
      isDisabled: isDisabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          ..._buildSection(
              "BSN nummer",
              buildTextField(
                controller: bsnNumberController,
                keyboardType: TextInputType.text,
                label: 'BSN nummer',
              )),
          ..._buildSection("Vervaldatum rijbewijs", buildDatePickerWidget()),
          ..._buildSection("Rijbewijs foto (voorkant)",
              _buildLicenseContainer(driverLicenseFront, 'front')),
          ..._buildSection("Rijbewijs foto (achterkant)",
              _buildLicenseContainer(driverLicenseBack, 'back')),
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
        SvgPicture.asset("assets/svg/Img_box_fill.svg",
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
                  SvgPicture.asset('assets/svg/camera.svg'),
                  const SizedBox(width: 10),
                  const Text('Maak een foto',
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
                minimumDate:
                    DateTime.now().subtract(const Duration(days: 3650)),
                maximumDate: DateTime.now().add(const Duration(days: 3650)),
                onDateTimeChanged: (DateTime dateTime) {
                  expiryDate =
                      DateFormat('dd/MM/yyyy', 'nl_NL').format(dateTime);
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
