class DamageReport {
  final int id;
  final String reportedAt;
  final String description;
  final String status;
  final double? amount;
  final String? repairedAt;
  final String vehicleId;
  final String userId;
  final List<String> images;

  DamageReport({
    required this.id,
    required this.reportedAt,
    required this.description,
    required this.status,
    this.amount,
    this.repairedAt,
    required this.vehicleId,
    required this.userId,
    required this.images,
  });

  factory DamageReport.fromJson(Map<String, dynamic> json) {
    return DamageReport(
      id: json['id'],
      reportedAt: json['reportedAt'],
      description: json['description'],
      status: json['status'],
      amount: json['amount']?.toDouble(),
      repairedAt: json['repairedAt'],
      vehicleId: json['vehicleId'],
      userId: json['userId'],
      images: List<String>.from(json['images'] ?? []),
    );
  }
}
