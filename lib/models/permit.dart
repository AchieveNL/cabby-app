class PermitRequest {
  final String? kiwaDocument;
  final String? kvkDocument;
  final String? taxiPermitId;
  final String? taxiPermitExpiry;
  final String? taxiPermitPicture;

  PermitRequest({
    this.kiwaDocument,
    this.kvkDocument,
    this.taxiPermitId,
    this.taxiPermitExpiry,
    this.taxiPermitPicture,
  });

  factory PermitRequest.fromJson(Map<String, dynamic> json) {
    return PermitRequest(
      kiwaDocument: json['kiwaDocument'] ?? '',
      kvkDocument: json['kvkDocument'] ?? '',
      taxiPermitId: json['taxiPermitId'] ?? '',
      taxiPermitExpiry: json['taxiPermitExpiry'] ?? '',
      taxiPermitPicture: json['taxiPermitPicture'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (kiwaDocument != null) {
      data['kiwaDocument'] = kiwaDocument;
    }
    if (kvkDocument != null) {
      data['kvkDocument'] = kvkDocument;
    }
    if (taxiPermitId != null) {
      data['taxiPermitId'] = taxiPermitId;
    }
    if (taxiPermitExpiry != null) {
      data['taxiPermitExpiry'] = taxiPermitExpiry;
    }
    if (taxiPermitPicture != null) {
      data['taxiPermitPicture'] = taxiPermitPicture;
    }
    return data;
  }
}
