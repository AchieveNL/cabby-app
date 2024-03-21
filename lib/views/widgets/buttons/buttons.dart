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
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const PrimaryButton({
    super.key,
    required this.btnText,
    this.height = 50,
    this.width = 250,
    this.radius = 25,
    this.isLoading = false,
    this.isDisabled = false,
    this.btnTextSize = 16,
    required this.onPressed,
    this.prefixIcon,
    this.suffixIcon,
  });

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
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (prefixIcon != null) prefixIcon!,
                    if (prefixIcon != null)
                      const SizedBox(
                        width: 10,
                      ),
                    Text(
                      btnText,
                      style: TextStyle(
                        fontSize: btnTextSize,
                        color: Colors.white,
                      ),
                    ),
                    if (suffixIcon != null) const SizedBox(width: 5),
                    if (suffixIcon != null) suffixIcon!,
                  ],
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
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback onPressed;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const SecondaryButton({
    super.key,
    required this.btnText,
    this.height = 50,
    this.width = 250,
    this.radius = 25,
    this.isLoading = false,
    this.isDisabled = false,
    this.btnTextSize = 16,
    required this.onPressed,
    this.prefixIcon,
    this.suffixIcon,
  });

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
              ? const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 20.0,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (prefixIcon != null) prefixIcon!,
                    if (prefixIcon != null) const SizedBox(width: 5),
                    Text(
                      btnText,
                      style: TextStyle(
                        fontSize: btnTextSize,
                        color:
                            isDisabled ? Colors.grey : AppColors.primaryColor,
                      ),
                    ),
                    if (suffixIcon != null) const SizedBox(width: 5),
                    if (suffixIcon != null) suffixIcon!,
                  ],
                ),
        ),
      ),
    );
  }
}

class DangerButton extends StatelessWidget {
  final String btnText;
  final double radius;
  final double height;
  final double? width;
  final double btnTextSize;
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback onPressed;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const DangerButton({
    super.key,
    required this.btnText,
    this.height = 50,
    this.width = 250,
    this.radius = 25,
    this.isLoading = false,
    this.isDisabled = false,
    this.btnTextSize = 16,
    required this.onPressed,
    this.prefixIcon,
    this.suffixIcon,
  });

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
            foregroundColor: Colors.red, // Danger color
            backgroundColor: Colors.transparent,
            side: BorderSide(
              color: isDisabled ? Colors.grey : Colors.red, // Danger color
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: isLoading
              ? const SpinKitThreeBounce(
                  color: Colors.red, // Danger color
                  size: 20.0,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (prefixIcon != null) prefixIcon!,
                    if (prefixIcon != null) const SizedBox(width: 5),
                    Text(
                      btnText,
                      style: TextStyle(
                        fontSize: btnTextSize,
                        color: isDisabled
                            ? Colors.grey
                            : Colors.red, // Danger color
                      ),
                    ),
                    if (suffixIcon != null) const SizedBox(width: 5),
                    if (suffixIcon != null) suffixIcon!,
                  ],
                ),
        ),
      ),
    );
  }
}

class SecondaryButtonWithIcon extends SecondaryButton {
  final Widget? btnIcon; // New Icon data

  const SecondaryButtonWithIcon({
    super.key,
    required super.btnText,
    super.height,
    super.width = null,
    super.radius,
    super.btnTextSize,
    super.isLoading,
    super.isDisabled,
    this.btnIcon, // Icon Constructor
    required super.onPressed,
  });

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
    super.key,
    this.height = 40,
    this.width = 250,
    this.radius = 5,
    this.padding = 0,
    required this.onPressed,
    required this.icon,
    this.btnColor = AppColors.primaryColor,
    this.letterSpacing = 0,
  });

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
