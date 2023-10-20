import 'package:cabby/views/screens/signup_screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatefulWidget {
  final Function(SignupData) dataCallback;
  final Function({required String title, required bool isDisabled}) btnCallback;

  const SignatureScreen({
    Key? key,
    required this.dataCallback,
    required this.btnCallback,
  }) : super(key: key);

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  bool _loading = false;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black, // Set pen color to black
    exportBackgroundColor:
        Colors.transparent, // Set background color to transparent
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
    if (newTab == 'Select') {
      _selectSignatureFromGallery();
    } else {
      setState(() {
        _selectedTab = newTab;
      });
    }
  }

  Future<void> _selectSignatureFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _selectedTab = 'Select';
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> _useSignature(double width, double height) async {
    if (_selectedTab == 'Draw') {
      _toggleLoading();
      final img = await _controller.toPngBytes(
          height: height.toInt(), width: width.toInt());
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      file.writeAsBytesSync(img!);
      widget.dataCallback(SignupData()..signatureImage = file);
      widget.btnCallback(title: "Submit", isDisabled: false);
    } else {
      widget.dataCallback(SignupData()..signatureImage = _selectedImage);
      widget.btnCallback(title: "Submit", isDisabled: false);
    }
    Navigator.of(context).pop();
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
            Icons.arrow_back, // Simplified the back arrow for clarity
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
    return Center(
      child: Container(
        width: size.width * .8,
        height: size.height,
        margin: const EdgeInsets.only(top: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTabs(),
              _buildSignatureContainer(size),
              _buildInstructionText(),
              _buildLoadingOrUseButton(size),
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
                height: size.height / 2,
                backgroundColor: Colors.transparent,
              ),
            ),
          )
        : Container(
            width: size.width,
            height: size.height * 0.6,
            child: _selectedImage != null
                ? GridView.count(
                    crossAxisCount: 3,
                    children: [Image.file(_selectedImage!)],
                  )
                : Center(child: Text('No image selected')),
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
    return _loading
        ? const CircularProgressIndicator()
        : Container(
            margin: const EdgeInsets.only(top: 30, bottom: 10),
            width: size.width * .7,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              color: Colors.blue, // Assuming this is your primary color
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Assuming this is your primary color
              ),
              onPressed: _isUseBtnDisabled
                  ? null
                  : () => _useSignature(size.width, size.height * 0.6),
              child: const Text(
                'Use Signature',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
  }

  Widget _buildDeleteButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_selectedTab == 'Draw') {
          _controller.clear();
          setState(() {
            _isUseBtnDisabled = true;
          });
        } else {
          setState(() {
            _selectedImage = null;
            _isUseBtnDisabled = true;
          });
        }
      },
      child: Container(
        width: size.width * .7,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border: Border.all(
              color: Colors.blue,
              width: 1), // Assuming this is your primary color
        ),
        child: Center(
          child: Text(
            'Delete Signature',
            style: TextStyle(
              color: Colors.blue, // Assuming this is your primary color
            ),
          ),
        ),
      ),
    );
  }
}
