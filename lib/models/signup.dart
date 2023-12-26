import 'dart:io';

class SignupEmailPassword {
  String? email;
  String? password;
  String? confirmPassword;
}

class SignupProfile {
  String? firstName;
  String? lastName;
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
  String? bsnNumber;
}

class SignupPermitDetails {
  File? taxiPermitFile;
  String? taxiPermitExpiry;
}

class SignupKvk {
  File? kvkFile;
}

class SignupKawi {
  File? kawiFile;
}

class SignupSignature {
  String? signature;
}
