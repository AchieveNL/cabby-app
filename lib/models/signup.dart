import 'dart:io';

class SignupEmailPassword {
  String? email;
  String? password;
  String? confirmPassword;
}

class SignupProfile {
  String? name;
  String? phone;
  String? zip;
  String? street;
  String? location;
  DateTime? dob;
  String? city;
}

class SignupDriverLicence {
  File? driverLicenseFront;
  File? driverLicenseBack;
  String? expiryDate;
}

class SignupPermitDetails {
  dynamic taxiPermitFile;
}

class SignupKvk {
  dynamic kvkFile;
}

class SignupKawi {
  dynamic kawiFile;
}

class SignupSignature {
  String? signature;
}
