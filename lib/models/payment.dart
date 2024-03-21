class CreatePaymentDto {
  final double amount;
  final String product;
  final String status;
  final DateTime? paymentDate;

  CreatePaymentDto({
    required this.amount,
    required this.product,
    required this.status,
    this.paymentDate,
  });

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'product': product,
        'status': status,
        'paymentDate': paymentDate?.toIso8601String(),
      };
}
