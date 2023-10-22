class DriverLicenseRequest {
  final String driverLicenseBack;
  final String driverLicenseFront;
  final String driverLicenseExpiry;
  final String? bsnNumber;
  final String? driverLicense;

  DriverLicenseRequest({
    required this.driverLicenseBack,
    required this.driverLicenseFront,
    required this.driverLicenseExpiry,
    this.bsnNumber,
    this.driverLicense,
  });

  factory DriverLicenseRequest.fromJson(Map<String, dynamic> json) {
    return DriverLicenseRequest(
      driverLicenseBack: json['driverLicenseBack'] ?? '',
      driverLicenseFront: json['driverLicenseFront'] ?? '',
      driverLicenseExpiry: json['driverLicenseExpiry'] ?? '',
      bsnNumber: json['bsnNumber'] ?? '',
      driverLicense: json['driverLicense'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['driverLicenseBack'] = driverLicenseBack;
    data['driverLicenseFront'] = driverLicenseFront;
    data['driverLicenseExpiry'] = driverLicenseExpiry;
    if (bsnNumber != null) {
      data['bsnNumber'] = bsnNumber;
    }
    if (driverLicense != null) {
      data['driverLicense'] = driverLicense;
    }
    return data;
  }
}
