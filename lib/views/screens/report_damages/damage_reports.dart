import 'dart:io';

import 'package:cabby/config/theme.dart';
import 'package:cabby/services/damage_report.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:cabby/views/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class DamageReportScreen extends StatefulWidget {
  final String? vehicleId;
  const DamageReportScreen({
    super.key,
    this.vehicleId,
  });

  @override
  _DamageReportScreenState createState() => _DamageReportScreenState();
}

class _DamageReportScreenState extends State<DamageReportScreen> {
  final TextEditingController _reportController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _imageFiles = [];
  bool _isSubmitting = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFiles.insert(0, pickedFile);
        });
      }
    } catch (e) {
      // Handle errors or cancelation
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  void _submitDamageReport() async {
    setState(() {
      _isSubmitting = true;
    });
    List<File> imageFiles =
        _imageFiles.map((xfile) => File(xfile.path)).toList();
    try {
      await DamageReportService().sendDamageReport(
        _reportController.text,
        widget.vehicleId!,
        imageFiles,
      );
      // ignore: use_build_context_synchronously
      ToastUtil.showToast(context, 'Schaderapport met succes verzonden');
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ToastUtil.showToast(context, 'Kan schaderapport niet verzenden');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schaderapport'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _reportController,
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                decoration: DecorationInputs.textBoxInputDecoration(
                  label: 'Vertel ons wat je hebt gevonden.',
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _imageFiles.asMap().entries.map((entry) {
                    int idx = entry.key;
                    XFile img = entry.value;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(File(img.path)),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Positioned(
                          top: -8,
                          right: -8,
                          child: IconButton(
                            icon: const Icon(Icons.cancel),
                            color: AppColors.primaryColor,
                            onPressed: () => _removeImage(idx),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _imageSelectionCard(
                      icon: SvgPicture.asset(
                        'assets/svg/camera.svg',
                        color: AppColors.primaryColor,
                        width: 50,
                        height: 50,
                      ),
                      text: "Een foto nemen",
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _imageSelectionCard(
                      icon: SvgPicture.asset(
                        'assets/svg/gallery.svg',
                        color: AppColors.primaryColor,
                        width: 50,
                        height: 50,
                      ),
                      text: "Kies uit gallerij",
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 140,
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          20,
        ),
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
        ),
        child: Column(
          children: [
            PrimaryButton(
              btnText: "Schaderapport indienen",
              onPressed: _submitDamageReport,
              width: screenSize.width,
              isDisabled: _isSubmitting,
              isLoading: _isSubmitting,
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              btnText: "Annuleren",
              onPressed: () {
                Navigator.of(context).pop();
              },
              width: screenSize.width,
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageSelectionCard({
    required Widget icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 10),
            Text(text),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reportController.dispose();
    super.dispose();
  }
}
