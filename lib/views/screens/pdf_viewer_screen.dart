import 'dart:io';
import 'package:cabby/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PDFViewerScreen extends StatefulWidget {
  final String title;
  final File? file;
  final String? url;

  const PDFViewerScreen({
    super.key,
    required this.title,
    this.file,
    this.url,
  });

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  late PDFViewController controller;
  int? pages = 0;
  int? currentPage = 0;
  String? pdfPath;

  @override
  void initState() {
    super.initState();
    if (widget.url != null) {
      downloadFile();
    }
  }

  Future<void> downloadFile() async {
    var file = await DefaultCacheManager().getSingleFile(widget.url!);
    setState(() {
      pdfPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.file == null && pdfPath == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ), // loading indicator
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.black),
            onPressed: () {
              if (currentPage! > 0) {
                currentPage = currentPage! - 1;
                controller.setPage(currentPage!);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.black),
            onPressed: () {
              if (currentPage! < pages! - 1) {
                currentPage = currentPage! + 1;
                controller.setPage(currentPage!);
              }
            },
          )
        ],
      ),
      body: PDFView(
        filePath: widget.file?.path ?? pdfPath,
        onViewCreated: (PDFViewController pdfViewController) {
          setState(() {
            controller = pdfViewController;
          });
        },
        onPageChanged: (int? page, int? total) {
          setState(() {
            currentPage = page;
            pages = total;
          });
        },
      ),
    );
  }
}
