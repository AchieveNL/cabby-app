import 'package:cabby/models/vehicle.dart';

class VehicleAvailability {
  final List<BookedPeriod> bookedPeriods;

  VehicleAvailability({required this.bookedPeriods});

  factory VehicleAvailability.fromJson(Map<String, dynamic> json) {
    var bookedJson = json['booked'] as List;
    List<BookedPeriod> booked =
        bookedJson.map((i) => BookedPeriod.fromJson(i)).toList();
    return VehicleAvailability(bookedPeriods: booked);
  }
}

class BookedPeriod {
  final DateTime from;
  final DateTime to;

  BookedPeriod({required this.from, required this.to});

  factory BookedPeriod.fromJson(Map<String, dynamic> json) {
    return BookedPeriod(
      from: DateTime.parse(json['from']),
      to: DateTime.parse(json['to']),
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
  final bool isVehicleUnlocked;

  OrderDetails({
    required this.order,
    required this.vehicle,
    required this.startCountdown,
    required this.endCountdown,
    required this.statusMessage,
    required this.orderMessage,
    required this.readyToUse,
    required this.isVehicleUnlocked,
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
      isVehicleUnlocked: json['isVehicleUnlocked'],
    );
  }
}

class OrderDetail extends OrderOverview {
  final String paymentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? note;
  final bool isVehicleUnlocked;

  OrderDetail({
    required super.id,
    required super.vehicle,
    required super.status,
    required super.totalAmount,
    required super.rentalStartDate,
    required super.rentalEndDate,
    required super.payment,
    required this.paymentId,
    required this.createdAt,
    required this.updatedAt,
    required this.isVehicleUnlocked,
    this.note,
  });

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
      isVehicleUnlocked: json['isVehicleUnlocked'],
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
    required super.id,
    required super.logo,
    required super.companyName,
    required super.model,
    required super.pricePerDay,
    required super.images,
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
  });

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
