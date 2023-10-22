import 'package:cabby/config/utils.dart';
import 'package:cabby/services/profile_service.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';

typedef SignatureCallback = void Function(String signatureUrl);

class SignatureScreen extends StatefulWidget {
  final SignatureCallback onSignatureComplete;

  const SignatureScreen({
    Key? key,
    required this.onSignatureComplete,
  }) : super(key: key);

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  bool _loading = false;
  final profileService = ProfileService();
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
  );
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  String _selectedTab = 'Draw';
  bool _isUseBtnDisabled = true;

  @override
  void initState() {
    super.initState();
    _controller.onDrawMove = _onDraw;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDraw() {
    setState(() {
      _isUseBtnDisabled = false;
    });
  }

  void _onChangeTab(String newTab) {
    logger(newTab);
    if (newTab == 'Select') {
      _selectSignatureFromGallery();
    } else {
      setState(() {
        _selectedTab = newTab;
      });
    }
  }

  Future<void> _selectSignatureFromGallery() async {
    // Request permissions before accessing the gallery
    var permissionStatus = await Permission.photos.request();

    logger(permissionStatus);

    if (permissionStatus.isGranted) {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Check if the image is PNG format
        if (image.path.split(".").last.toLowerCase() == 'png') {
          setState(() {
            _selectedImage = File(image.path);
            _selectedTab = 'Select';
            _isUseBtnDisabled =
                false; // User has selected a valid image, so enable the "Use Signature" button
          });
        } else {
          // Inform user that only PNG images are allowed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select a PNG image.")),
          );
        }
      }
    } else if (permissionStatus.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permissions now is to manually
      // do it in the system settings.
      // openAppSettings();
    }
  }

  Future<void> _useSignature(double width, double height) async {
    File? signatureFile;

    if (_selectedTab == 'Draw') {
      _toggleLoading();
      final img = await _controller.toPngBytes(
          height: height.toInt(), width: width.toInt());
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      file.writeAsBytesSync(img!);
      signatureFile = file;
    } else {
      signatureFile = File(_selectedImage!.path);
    }

    try {
      final response =
          await profileService.createRentalAgreement(signatureFile);
      logger("Successfully uploaded the signature: $response");

      if (response.containsKey('payload') &&
          response['payload'].containsKey('url')) {
        widget.onSignatureComplete(response['payload']['url']);
      }
      Navigator.of(context).pop();
    } catch (e) {
      logger("Error uploading the signature: $e");
    }

    // widget.btnCallback(title: "Submit", isDisabled: false);
    // Navigator.of(context).pop();
  }

  void _toggleLoading() {
    setState(() {
      _loading = !_loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(size),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white, // Changed to white
      elevation: 0,
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
      title: const Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          'Your Signature',
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(Size size) {
    Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: size.width * .8,
        height: size.height,
        margin: const EdgeInsets.only(top: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTabs(),
              SizedBox(height: screenSize.height * 0.02),
              _buildSignatureContainer(size),
              SizedBox(height: screenSize.height * 0.02),
              _buildInstructionText(),
              SizedBox(height: screenSize.height * 0.02),
              _buildLoadingOrUseButton(size),
              SizedBox(height: screenSize.height * 0.02),
              _buildDeleteButton(size),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildTabs() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _onChangeTab('Draw'),
            child: Text(
              'Draw',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight:
                    _selectedTab == 'Draw' ? FontWeight.w700 : FontWeight.w400,
                fontSize: 16,
                color: _selectedTab == 'Draw' ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => _onChangeTab('Select'),
            child: Text(
              'Select',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: _selectedTab == 'Select'
                    ? FontWeight.w700
                    : FontWeight.w400,
                fontSize: 16,
                color: _selectedTab == 'Select' ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignatureContainer(Size size) {
    return _selectedTab == 'Draw'
        ? Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                  color: Colors.black, width: 2), // Set border color to black
            ),
            margin: const EdgeInsets.only(top: 30, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Center(
              child: Signature(
                controller: _controller,
                width: 300,
                height: size.height / 3,
                backgroundColor: Colors.transparent,
              ),
            ),
          )
        : SizedBox(
            width: size.width,
            height: size.height * 0.6,
            child: _selectedImage != null
                ? GridView.count(
                    crossAxisCount: 3,
                    children: [Image.file(_selectedImage!)],
                  )
                : const Center(child: Text('No image selected')),
          );
  }

  Text _buildInstructionText() {
    return const Text(
      'Draw your signature inside the area or select from gallery',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildLoadingOrUseButton(Size size) {
    return PrimaryButton(
      btnText: 'Use Signature',
      width: size.width * .7,
      height: 48,
      isLoading: _loading,
      isDisabled: _isUseBtnDisabled,
      onPressed: () => _useSignature(size.width, size.height * 0.6),
    );
  }

  Widget _buildDeleteButton(Size size) {
    return SecondaryButton(
      btnText: 'Delete Signature',
      width: size.width * .7,
      height: 48,
      onPressed: () {
        if (_selectedTab == 'Draw') {
          _controller.clear();
        } else {
          _selectedImage = null;
        }
        setState(() {
          _isUseBtnDisabled = true;
        });
      },
    );
  }
}
