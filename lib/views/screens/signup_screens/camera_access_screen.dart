// ignore_for_file: use_build_context_synchronously

import 'package:cabby/config/utils.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraAccessScreen extends StatelessWidget {
  final Function onCameraAccessGranted;
  const CameraAccessScreen({super.key, required this.onCameraAccessGranted});

  Future<void> _requestCameraPermission(BuildContext context) async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      Navigator.of(context).pop();
      onCameraAccessGranted();
    } else {
      // Handle denial of permission or provide info to user.
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cameramotor is vereist!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons
                  .arrow_back_ios_new_rounded, // Simplified the back arrow for clarity
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/svg/camera.svg',
              width: 120,
              height: 120,
              color: Colors.blueGrey[300],
            ),
            const SizedBox(height: 40),
            Text(
              "Camera toegang toestaan",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[700],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Wanneer u wordt gevraagd, moet u de toegang tot de camera inschakelen om door te gaan.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey[600],
              ),
            ),
            const Spacer(),
            Text(
              "We kunnen je niet verifieren zonder je camera",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            PrimaryButton(
              width: screenSize.width * 0.9,
              height: 50,
              btnText: "Zet de camera aan",
              onPressed: () {
                _requestCameraPermission(context);
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
