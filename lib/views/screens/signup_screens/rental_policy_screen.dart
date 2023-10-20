import 'package:cabby/views/screens/signup_screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class RentalPolicy extends StatefulWidget {
  final Function(SignupData) dataCallback;
  final Function({required String title, required bool isDisabled}) btnCallback;

  const RentalPolicy({
    Key? key,
    required this.dataCallback,
    required this.btnCallback,
  }) : super(key: key);

  @override
  State<RentalPolicy> createState() => _RentalPolicyState();
}

class _RentalPolicyState extends State<RentalPolicy> {
  String? pdfPath;

  @override
  void initState() {
    super.initState();
    _downloadPdf();
  }

  _downloadPdf() async {
    var url =
        'https://www.mieterbund.de/fileadmin/public/dmb-wohnungsmietvertrag_engl.pdf';
    var response = await http.get(Uri.parse(url));

    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/temp.pdf");

    await file.writeAsBytes(response.bodyBytes);
    setState(() {
      pdfPath = file.path;
    });
    widget.btnCallback(title: "Create a signature", isDisabled: false);
  }

  @override
  Widget build(BuildContext context) {
    return pdfPath != null
        ? PDFView(
            filePath: pdfPath!,
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
