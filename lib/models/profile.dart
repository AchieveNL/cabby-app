class UserProfile {
  final String city;
  final String fullAddress;
  final String fullName;
  final String lastName;
  final String firstName;
  final String phoneNumber;
  final String zip;
  final String? profilePhoto;
  final String? signature;
  final String? dateOfBirth;

  UserProfile({
    required this.city,
    required this.fullAddress,
    required this.fullName,
    required this.lastName,
    required this.firstName,
    required this.phoneNumber,
    required this.zip,
    this.profilePhoto,
    this.signature,
    this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'fullAddress': fullAddress,
      'fullName': fullName,
      'lastName': lastName,
      'firstName': firstName,
      'phoneNumber': phoneNumber,
      'zip': zip,
      'dateOfBirth': dateOfBirth,
      if (profilePhoto != null) 'profilePhoto': profilePhoto,
      if (signature != null) 'signature': signature,
    };
  }
}

class EditUserProfile {
  final String? city;
  final String? fullAddress;
  final String? fullName;
  final String? lastName;
  final String? firstName;
  final String? phoneNumber;
  final String? zip;
  final String? profilePhoto;
  final String? signature;

  EditUserProfile({
    this.city,
    this.fullAddress,
    this.fullName,
    this.lastName,
    this.firstName,
    this.phoneNumber,
    this.zip,
    this.profilePhoto,
    this.signature,
  });

  // Add methods to convert from/to JSON if needed
}

class UpdateExpiryDate {
  final String driverLicenseExpiry;
  final String taxiPermitExpiry;

  UpdateExpiryDate({
    required this.driverLicenseExpiry,
    required this.taxiPermitExpiry,
  });

  // Add methods to convert from/to JSON if needed
}

class UserProfileModel {
  final String id;
  final String userId;
  final String city;
  final String fullAddress;
  final String fullName;
  final String lastName;
  final String firstName;
  final String phoneNumber;
  final String? profilePhoto;
  final String signature;
  final String zip;
  final String status;

  UserProfileModel({
    required this.id,
    required this.userId,
    required this.city,
    required this.fullAddress,
    required this.fullName,
    required this.lastName,
    required this.firstName,
    required this.phoneNumber,
    this.profilePhoto,
    required this.signature,
    required this.zip,
    required this.status,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      city: json['city'] ?? '',
      fullAddress: json['fullAddress'] ?? '',
      fullName: json['fullName'] ?? '',
      lastName: json['lastName'] ?? '',
      firstName: json['firstName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profilePhoto: json['profilePhoto'],
      signature: json['signature'] ?? '',
      zip: json['zip'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'city': city,
      'fullAddress': fullAddress,
      'fullName': fullName,
      'lastName': lastName,
      'firstName': firstName,
      'phoneNumber': phoneNumber,
      'profilePhoto': profilePhoto,
      'signature': signature,
      'zip': zip,
      'status': status,
    };
  }
}
