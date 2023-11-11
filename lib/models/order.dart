import 'package:cabby/models/vehicle.dart';

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

class OrderDetails {
  final OrderDetail order;
  final Vehicle vehicle;
  final double startCountdown;
  final double endCountdown;
  final String statusMessage;
  final String orderMessage;
  final bool readyToUse;

  OrderDetails({
    required this.order,
    required this.vehicle,
    required this.startCountdown,
    required this.endCountdown,
    required this.statusMessage,
    required this.orderMessage,
    required this.readyToUse,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      order: OrderDetail.fromJson(json['order']),
      vehicle: Vehicle.fromJson(json['vehicle']),
      startCountdown: json['startCountdown'].toDouble(),
      endCountdown: json['endCountdown'].toDouble(),
      statusMessage: json['statusMessage'],
      orderMessage: json['orderMessage'],
      readyToUse: json['readyToUse'],
    );
  }
}

class OrderDetail extends OrderOverview {
  final String paymentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? note;

  OrderDetail({
    required String id,
    required OrderOverviewVehicle vehicle,
    required String status,
    required String totalAmount,
    required String rentalStartDate,
    required String rentalEndDate,
    required OrderOverviewPayment payment,
    required this.paymentId,
    required this.createdAt,
    required this.updatedAt,
    this.note,
  }) : super(
          id: id,
          vehicle: vehicle,
          status: status,
          totalAmount: totalAmount,
          rentalStartDate: rentalStartDate,
          rentalEndDate: rentalEndDate,
          payment: payment,
        );

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      vehicle: OrderOverviewVehicle.fromJson(json['vehicle']),
      status: json['status'],
      totalAmount: json['totalAmount'],
      rentalStartDate: json['rentalStartDate'],
      rentalEndDate: json['rentalEndDate'],
      payment: OrderOverviewPayment.fromJson({
        'invoiceUrl': ''
      }), // Placeholder, modify if you have actual payment data
      paymentId: json['paymentId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      note: json['note'],
    );
  }
}

class OrderDetailVehicle extends OrderOverviewVehicle {
  final String rentalDuration;
  final String licensePlate;
  final String category;
  final String manufactureYear;
  final String engineType;
  final String seatingCapacity;
  final String batteryCapacity;
  final String uniqueFeature;
  final String availability;
  final String? unavailabilityReason;
  final String currency;
  final String status;

  OrderDetailVehicle({
    required String id,
    required String logo,
    required String companyName,
    required String model,
    required String pricePerDay,
    required List<String> images,
    required this.rentalDuration,
    required this.licensePlate,
    required this.category,
    required this.manufactureYear,
    required this.engineType,
    required this.seatingCapacity,
    required this.batteryCapacity,
    required this.uniqueFeature,
    required this.availability,
    this.unavailabilityReason,
    required this.currency,
    required this.status,
  }) : super(
          id: id,
          logo: logo,
          companyName: companyName,
          model: model,
          pricePerDay: pricePerDay,
          images: images,
        );

  factory OrderDetailVehicle.fromJson(Map<String, dynamic> json) {
    return OrderDetailVehicle(
      id: json['id'],
      logo: json['logo'],
      companyName: json['companyName'],
      model: json['model'],
      pricePerDay: json['pricePerDay'],
      images: List<String>.from(json['images']),
      rentalDuration: json['rentalDuration'],
      licensePlate: json['licensePlate'],
      category: json['category'],
      manufactureYear: json['manufactureYear'],
      engineType: json['engineType'],
      seatingCapacity: json['seatingCapacity'],
      batteryCapacity: json['batteryCapacity'],
      uniqueFeature: json['uniqueFeature'],
      availability: json['availability'],
      unavailabilityReason: json['unavailabilityReason'],
      currency: json['currency'],
      status: json['status'],
    );
  }
}
