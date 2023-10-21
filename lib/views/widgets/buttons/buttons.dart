import 'package:cabby/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PrimaryButton extends StatelessWidget {
  final String btnText;
  final double radius;
  final double height;
  final double? width;
  final double btnTextSize;
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback onPressed;

  const PrimaryButton({
    Key? key,
    required this.btnText,
    this.height = 50,
    this.width = 250,
    this.radius = 25,
    this.isLoading = false,
    this.isDisabled = false,
    this.btnTextSize = 16,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: MediaQuery.of(context).size.height > 550 ? height : 30,
        width: width ?? MediaQuery.of(context).size.width - 30,
        child: ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDisabled ? Colors.grey : AppColors.primaryColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: isLoading
              ? const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 20.0,
                )
              : Text(
                  btnText,
                  style: TextStyle(
                    fontSize: btnTextSize,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String btnText;
  final double radius;
  final double height;
  final double? width;
  final double btnTextSize;
  final bool isLoading; // loading state
  final bool isDisabled; // disabled state
  final VoidCallback onPressed;

  const SecondaryButton({
    Key? key,
    required this.btnText,
    this.height = 50,
    this.width = 250,
    this.radius = 25,
    this.isLoading = false,
    this.isDisabled = false,
    this.btnTextSize = 16,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: MediaQuery.of(context).size.height > 550 ? height : 30,
        width: width ?? MediaQuery.of(context).size.width - 30,
        child: OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
            backgroundColor: Colors.transparent, // Text color
            side: BorderSide(
              color: isDisabled ? Colors.grey : AppColors.primaryColor, // Border color
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                  strokeWidth: 2.0,
                )
              : Text(
                  btnText,
                  style: TextStyle(
                    fontSize: btnTextSize,
                  ),
                ),
        ),
      ),
    );
  }
}

class SecondaryButtonWithIcon extends SecondaryButton {
  final Widget? btnIcon; // New Icon data

  const SecondaryButtonWithIcon({
    Key? key,
    required String btnText,
    double height = 50,
    double? width,
    double radius = 25,
    double btnTextSize = 16,
    bool isLoading = false,
    bool isDisabled = false,
    this.btnIcon, // Icon Constructor
    required VoidCallback onPressed,
  }) : super(
          key: key,
          btnText: btnText,
          height: height,
          width: width,
          radius: radius,
          btnTextSize: btnTextSize,
          isLoading: isLoading,
          isDisabled: isDisabled,
          onPressed: onPressed,
        );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: MediaQuery.of(context).size.height > 550 ? height : 30,
        width: width ?? MediaQuery.of(context).size.width - 30,
        child: OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
            backgroundColor: Colors.transparent,
            side: BorderSide(
              color: isDisabled ? Colors.grey : AppColors.primaryColor,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: isLoading
              ? const CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                  strokeWidth: 2.0,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Align the icon and text to the center
                  children: [
                    if (btnIcon != null) btnIcon!,
                    if (btnIcon != null)
                      const SizedBox(width: 10), // space between icon and text
                    Text(
                      btnText,
                      style: TextStyle(
                        fontSize: btnTextSize,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}


class ButtonWithIcon extends StatelessWidget {
  final double radius;
  final double height;
  final double? width;
  final double padding;
  final VoidCallback onPressed;
  final Color btnColor;
  final Widget icon;
  final double letterSpacing;

  const ButtonWithIcon({
    Key? key,
    this.height = 40,
    this.width = 250,
    this.radius = 5,
    this.padding = 0,
    required this.onPressed,
    required this.icon,
    this.btnColor = AppColors.primaryColor,
    this.letterSpacing = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 50,
        width: width ?? MediaQuery.of(context).size.width - 30,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(btnColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
            padding: MaterialStateProperty.all(EdgeInsets.all(padding)),
          ),
          child: icon,
        ),
      ),
    );
  }
}
