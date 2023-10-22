// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cabby/config/theme.dart';
import 'package:cabby/models/signup.dart';
import 'package:cabby/views/screens/signup_screens/camera_access_screen.dart';
import 'package:cabby/views/screens/signup_screens/camera_screen.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PermitDetails extends StatefulWidget {
  final Function(SignupPermitDetails) dataCallback;
  final Function({required String title, required bool isDisabled}) btnCallback;
  final SignupPermitDetails permitDetailsData;
  const PermitDetails({
    Key? key,
    required this.dataCallback,
    required this.btnCallback,
    required this.permitDetailsData,
  }) : super(key: key);

  @override
  State<PermitDetails> createState() => _PermitDetailsState();
}

class _PermitDetailsState extends State<PermitDetails> {
  late File? taxiPermitFile;
  late String? taxiPermitExpiry;
  final TextEditingController expiryDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    taxiPermitFile = widget.permitDetailsData.taxiPermitFile;
    taxiPermitExpiry = widget.permitDetailsData.taxiPermitExpiry;
    if (taxiPermitExpiry != null) {
      expiryDateController.text = taxiPermitExpiry!;
    }
  }

  Future<void> pickImage() async {
    if (kDebugMode) {
      await _loadImageFromUrl(
          "https://storage.googleapis.com/cabby-bucket/images/front.png");
      validateForm();
      return;
    }

    final status = await Permission.camera.status;
    if (status.isGranted) {
      _navigateToCameraScreen();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraAccessScreen(
            onCameraAccessGranted: () {
              _navigateToCameraScreen();
            },
          ),
        ),
      );
    }
  }

  Future<void> _loadImageFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/temp.png');
    file.writeAsBytesSync(response.bodyBytes);
    setState(() {
      taxiPermitFile = file;
    });
  }

  void _navigateToCameraScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          onImageCaptured: (file) {
            setState(() {
              taxiPermitFile = file;
            });
            validateForm();
          },
          name: "Taxi permission photo",
        ),
      ),
    );
  }

  void onDataFromCustomDatePicker(String date) {
    setState(() {
      taxiPermitExpiry = date;
    });
    validateForm();
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
                onDateTimeChanged: (DateTime newDateTime) {
                  final format = DateFormat("dd/MM/yyyy");
                  final date = format.format(newDateTime);
                  expiryDateController.text = date;
                  onDataFromCustomDatePicker(date);
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

  void validateForm() {
    bool isFormValid = taxiPermitFile != null;
    widget.btnCallback(title: "Next", isDisabled: !isFormValid);

    SignupPermitDetails data = SignupPermitDetails()
      ..taxiPermitFile = taxiPermitFile
      ..taxiPermitExpiry = taxiPermitExpiry;
    widget.dataCallback(data);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
         children: <Widget>[
          ..._buildSection("Taxi permission expire date", buildDatePickerWidget()),
          ..._buildSection(
              "Taxi permission photo", _buildLicenseContainer(taxiPermitFile)),
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

  Widget _buildLicenseContainer(File? licenseFile) {
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
              : _buildPlaceHolder(),
        ),
      ],
    );
  }

  Widget _buildPlaceHolder() {
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
            onTap: () => pickImage(),
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
}
