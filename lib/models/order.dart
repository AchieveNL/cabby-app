class VehicleAvailability {
  final Map<String, Map<String, Map<String, bool>>> availability;

  VehicleAvailability({required this.availability});

  factory VehicleAvailability.fromJson(Map<String, dynamic> json) {
    return VehicleAvailability(
      availability: (json).map(
        (key, value) => MapEntry(
          key,
          (value as Map<String, dynamic>).map(
            (timeKey, timeValue) => MapEntry(
              timeKey,
              (timeValue as Map<String, dynamic>).map(
                (rangeKey, rangeValue) =>
                    MapEntry(rangeKey, rangeValue as bool),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum OrderStatus {
  PENDING,
  CONFIRMED,
  REJECTED,
  CANCELLED,
  COMPLETED,
  UNPAID,
}

class OrderOverview {
  final String id;
  final OrderOverviewVehicle vehicle;
  final String status;
  final String totalAmount;
  final String rentalStartDate;
  final String rentalEndDate;
  final OrderOverviewPayment payment;

  OrderOverview({
    required this.id,
    required this.vehicle,
    required this.status,
    required this.totalAmount,
    required this.rentalStartDate,
    required this.rentalEndDate,
    required this.payment,
  });

  factory OrderOverview.fromJson(Map<String, dynamic> json) {
    return OrderOverview(
      id: json['id'],
      vehicle: OrderOverviewVehicle.fromJson(json['vehicle']),
      status: json['status'],
      totalAmount: json['totalAmount'],
      rentalStartDate: json['rentalStartDate'],
      rentalEndDate: json['rentalEndDate'],
      payment: OrderOverviewPayment.fromJson(json['payment']),
    );
  }
}

class OrderOverviewVehicle {
  final String id;
  final String logo;
  final String companyName;
  final String model;
  final String pricePerDay;
  final List<String> images;

  OrderOverviewVehicle({
    required this.id,
    required this.logo,
    required this.companyName,
    required this.model,
    required this.pricePerDay,
    required this.images,
  });

  factory OrderOverviewVehicle.fromJson(Map<String, dynamic> json) {
    return OrderOverviewVehicle(
      id: json['id'],
      logo: json['logo'],
      companyName: json['companyName'],
      model: json['model'],
      pricePerDay: json['pricePerDay'],
      images: List<String>.from(json['images']),
    );
  }
}

class OrderOverviewPayment {
  final String invoiceUrl;

  OrderOverviewPayment({required this.invoiceUrl});

  factory OrderOverviewPayment.fromJson(Map<String, dynamic> json) {
    return OrderOverviewPayment(
      invoiceUrl: json['invoiceUrl'],
    );
  }
}
