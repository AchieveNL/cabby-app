import 'dart:io';
import 'package:cabby/config/utils.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class CameraScreen extends StatefulWidget {
  final String name;
  final Function(File) onImageCaptured;

  const CameraScreen(
      {super.key, required this.onImageCaptured, required this.name});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(firstCamera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: screenSize.width / screenSize.height,
                  child: CameraPreview(_controller),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          _buildOverlay(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 32.0,
            child: _buildTakePictureButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 3.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            "Plaats je document in het kader en zorg dat het voldoende belicht is.",
            style: TextStyle(color: Colors.white, fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTakePictureButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: PrimaryButton(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 50,
          btnText: "Maak een foto",
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              final image = await _controller.takePicture();
              final file = File(image.path);
              final croppedFile = await cropImageToFile(file);
              logger(croppedFile);
              widget.onImageCaptured(croppedFile);
              Navigator.pop(context);
            } catch (e) {
              logger(e);
            }
          },
        ),
      ),
    );
  }

  Future<File> cropImageToFile(File file) async {
    final overlayWidth = MediaQuery.of(context).size.width * 0.9;
    final overlayHeight = MediaQuery.of(context).size.width * 0.7;
    final overlayTop = (MediaQuery.of(context).size.height - overlayHeight) / 2;
    final overlayLeft = MediaQuery.of(context).size.width * 0.05;

    final image = img.decodeImage(await file.readAsBytes())!;
    final imageWidth = image.width.toDouble();
    final imageHeight = image.height.toDouble();

    final x =
        (overlayLeft / MediaQuery.of(context).size.width * imageWidth).round();
    final y =
        (overlayTop / MediaQuery.of(context).size.height * imageHeight).round();
    final width =
        (overlayWidth / MediaQuery.of(context).size.width * imageWidth).round();
    final height =
        (overlayHeight / MediaQuery.of(context).size.height * imageHeight)
            .round();

    final cropped =
        img.copyCrop(image, x: x, y: y, width: width, height: height);
    final croppedFile = File(file.path.replaceFirst(".jpg", "_cropped.jpg"));
    await croppedFile.writeAsBytes(img.encodeJpg(cropped));
    return croppedFile;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
