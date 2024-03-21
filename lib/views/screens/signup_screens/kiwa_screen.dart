import 'dart:io';
import 'package:cabby/config/theme.dart';
import 'package:cabby/models/signup.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KiwaScreen extends StatefulWidget {
  final Function(SignupKawi) dataCallback;
  final Function({required String title, required bool isDisabled}) btnCallback;
  final SignupKawi kawiData;

  const KiwaScreen({
    super.key,
    required this.dataCallback,
    required this.btnCallback,
    required this.kawiData,
  });

  @override
  State<KiwaScreen> createState() => _KiwaScreenState();
}

class _KiwaScreenState extends State<KiwaScreen> {
  late dynamic kawiFile;
  String? fileSizeError;

  @override
  void initState() {
    super.initState();
    kawiFile = widget.kawiData.kawiFile;
  }

  static const double maxFileSizeInMB = 5.0;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      double fileSizeInMB = file.lengthSync() / (1024 * 1024);

      if (fileSizeInMB > maxFileSizeInMB) {
        setState(() {
          fileSizeError =
              "Bestandsgrootte overschrijdt ${maxFileSizeInMB}MB begrenzing.";
          kawiFile = null;
        });
      } else {
        setState(() {
          kawiFile = file;
          fileSizeError = null;
        });
        // Updating SignupData
        widget.dataCallback(SignupKawi()..kawiFile = kawiFile);
        // Enabling the Next button after a successful file upload.
        widget.btnCallback(title: "Volgende", isDisabled: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Form(
      child: Column(
        children: <Widget>[
          _buildHeaderRow("KIWA taxivergunning"),
          _buildFileUploader(screenSize),
          const SizedBox(height: 20),
          if (fileSizeError != null)
            Text(
              fileSizeError!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ), // Display the error if there is any
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

  Widget _buildFileUploader(Size screenSize) {
    if (kawiFile != null) {
      return _buildFileRow();
    } else {
      return _buildUploadButton();
    }
  }

  Row _buildFileRow() {
    return Row(
      children: <Widget>[
        SvgPicture.asset('assets/svg/pdfIcon.svg'),
        const SizedBox(width: 20),
        const Text('KIWA taxivergunning'),
        const Spacer(),
        IconButton(
          onPressed: () {
            setState(() {
              kawiFile = null;
            });
          },
          icon: SvgPicture.asset('assets/svg/close-circle.svg'),
        ),
      ],
    );
  }

  Widget _buildUploadButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SecondaryButtonWithIcon(
        btnText: 'Upload bestand',
        btnIcon: SvgPicture.asset(
          'assets/svg/document-text.svg',
          color: AppColors.primaryColor,
        ), // Change to the icon you want
        onPressed: pickFile,
        isLoading: false,
        isDisabled: false,
      ),
    );
  }
}
