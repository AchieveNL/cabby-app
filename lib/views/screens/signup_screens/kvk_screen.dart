import 'dart:io';

import 'package:cabby/config/theme.dart';
import 'package:cabby/models/signup.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KvkScreen extends StatefulWidget {
  final Function(SignupKvk) dataCallback;
  final Function({required String title, required bool isDisabled}) btnCallback;
  final SignupKvk kvkData;
  const KvkScreen({
    super.key,
    required this.dataCallback,
    required this.btnCallback,
    required this.kvkData,
  });

  @override
  State<KvkScreen> createState() => _KvkScreenState();
}

class _KvkScreenState extends State<KvkScreen> {
  late File? kvkFile;

  @override
  void initState() {
    super.initState();
    kvkFile = widget.kvkData.kvkFile;
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        kvkFile = File(result.files.single.path!);

        // Create a SignupData object with the picked file
        SignupKvk data = SignupKvk();
        data.kvkFile = kvkFile;

        // Pass the updated SignupData to the parent
        widget.dataCallback(data);

        // If the file is not null, update the button to enable and set its title
        widget.btnCallback(title: "Volgende", isDisabled: false);
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
          SizedBox(height: screenSize.height * 0.02),
          _buildFileUploader(screenSize),
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
      return _buildUploadButton();
    }
  }

  Row _buildFileRow() {
    return Row(
      children: <Widget>[
        SvgPicture.asset('assets/pdfIcon.svg'),
        const SizedBox(width: 20),
        const Text('KVK document'),
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

  Widget _buildUploadButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SecondaryButtonWithIcon(
        btnText: 'Upload bestand',
        btnIcon: SvgPicture.asset(
          'assets/document-text.svg',
          color: AppColors.primaryColor,
        ), // Change to the icon you want
        onPressed: pickFile,
        isLoading: false,
        isDisabled: false,
      ),
    );
  }
}
