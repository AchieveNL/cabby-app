import 'package:cabby/config/config.dart';
import 'package:cabby/models/signup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pdf_image_renderer/pdf_image_renderer.dart';

class RentalPolicy extends StatefulWidget {
  final Function({required String title, required bool isDisabled}) btnCallback;
  final SignupSignature signatureData;

  const RentalPolicy({
    super.key,
    required this.btnCallback,
    required this.signatureData,
  });

  @override
  State<RentalPolicy> createState() => _RentalPolicyState();
}

class _RentalPolicyState extends State<RentalPolicy> {
  String? pdfPath;
  List<Uint8List>? pdfImages;
  String rentalAgreementUrl = AppConfig.rentalAgreementUrl;

  @override
  void initState() {
    super.initState();
    _downloadPdf();
  }

  @override
  void didUpdateWidget(RentalPolicy oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.signatureData.signature != widget.signatureData.signature) {
      widget.btnCallback(title: "Account aanmaken", isDisabled: true);
      _downloadPdf();
    }
  }

  _downloadPdf() async {
    String url = widget.signatureData.signature ?? rentalAgreementUrl;
    var response = await http.get(Uri.parse(url));

    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/temp.pdf");

    await file.writeAsBytes(response.bodyBytes);
    setState(() {
      pdfPath = file.path;
    });
    final renderedImages = await renderPdfImages(pdfPath!);
    setState(() {
      pdfImages = renderedImages;
    });

    if (widget.signatureData.signature == null) {
      widget.btnCallback(title: "Zet je handtekening", isDisabled: false);
    } else {
      widget.btnCallback(title: "Account aanmaken", isDisabled: false);
    }
  }

  Future<List<Uint8List>> renderPdfImages(String pdfPath) async {
    final pdfRenderer = PdfImageRendererPdf(path: pdfPath);

    await pdfRenderer.open();
    final pageCount = await pdfRenderer.getPageCount();

    List<Uint8List> images = [];
    for (int i = 0; i < pageCount; i++) {
      await pdfRenderer.openPage(pageIndex: i);
      final size = await pdfRenderer.getPageSize(pageIndex: i);

      final img = await pdfRenderer.renderPage(
        pageIndex: i,
        x: 0,
        y: 0,
        width: size.width,
        height: size.height,
        scale: 1,
        background: Colors.white,
      );
      await pdfRenderer.closePage(pageIndex: i);
      if (img != null) images.add(img);
    }

    await pdfRenderer.close();

    return images;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Form(
      child: Column(
        children: [
          _buildHeaderRow("Huurovereenkomst"),
          const SizedBox(height: 20.0),
          ...?pdfImages?.map(
            (image) => Image.memory(
              image,
              width: screenSize.width, // Adjusting to screen width
              fit: BoxFit.fill, // Adjusting fit to fill the space
              scale: 2,
            ),
          ),
          if (pdfImages == null) const CircularProgressIndicator(),
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
}
