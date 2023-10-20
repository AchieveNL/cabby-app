import 'dart:io';

import 'package:cabby/config/theme.dart';
import 'package:cabby/views/screens/signup_screens/signup_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KvkScreen extends StatefulWidget {
  final Function(SignupData)
      dataCallback; // New callback for updating SignupData
  final Function btnCallback; // New callback for updating button properties

  const KvkScreen(
      {Key? key, required this.dataCallback, required this.btnCallback})
      : super(key: key);

  @override
  State<KvkScreen> createState() => _KvkScreenState();
}

class _KvkScreenState extends State<KvkScreen> {
  dynamic kvkFile;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        kvkFile = File(result.files.single.path!);

        // Create a SignupData object with the picked file
        SignupData data = SignupData();
        data.kvkFile = kvkFile;

        // Pass the updated SignupData to the parent
        widget.dataCallback(data);

        // If the file is not null, update the button to enable and set its title
        widget.btnCallback(title: "Next", isDisabled: false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Form(
      child: Column(
        children: <Widget>[
          _buildHeaderRow("KVK document"),
          _buildFileUploader(screenSize),
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

  Widget _buildFileUploader(Size screenSize) {
    if (kvkFile != null) {
      return _buildFileRow();
    } else {
      return _buildUploadButton(screenSize);
    }
  }

  Row _buildFileRow() {
    return Row(
      children: <Widget>[
        SvgPicture.asset('assets/pdfIcon.svg'),
        const SizedBox(width: 20),
        const Text('Kiwa taxi vergunning Document'),
        const Spacer(),
        IconButton(
          onPressed: () {
            setState(() {
              kvkFile = null;

              // Set the button to be disabled if the file is removed
              widget.btnCallback(title: "Next", isDisabled: true);
            });
          },
          icon: SvgPicture.asset('assets/close-circle.svg'),
        ),
      ],
    );
  }

  OutlinedButton _buildUploadButton(Size screenSize) {
    return OutlinedButton.icon(
      onPressed: pickFile,
      style: ButtonStyle(
        iconColor:
            MaterialStateColor.resolveWith((states) => AppColors.primaryColor),
        iconSize: MaterialStateProperty.all(24),
      ),
      icon: SvgPicture.asset('assets/document-text.svg'),
      label: const Text(
        'Upload File',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
