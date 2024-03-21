class Vehicle {
  final String id;
  final String? logo;
  final String companyName;
  final String model;
  final String rentalDuration;
  final String? licensePlate;
  final String? category;
  final String manufactureYear;
  final String engineType;
  final String seatingCapacity;
  final String batteryCapacity;
  final String uniqueFeature;
  final List<String> images;
  final String? availability;
  final String? unavailabilityReason;
  final String? currency;
  final double? pricePerDay;

  Vehicle({
    required this.id,
    this.logo,
    required this.companyName,
    required this.model,
    required this.rentalDuration,
    this.licensePlate,
    this.category,
    required this.manufactureYear,
    required this.engineType,
    required this.seatingCapacity,
    required this.batteryCapacity,
    required this.uniqueFeature,
    required this.images,
    this.availability,
    this.unavailabilityReason,
    this.currency,
    this.pricePerDay,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      logo: json['logo'],
      companyName: json['companyName'],
      model: json['model'],
      rentalDuration: json['rentalDuration'],
      licensePlate: json['licensePlate'],
      category: json['category'],
      manufactureYear: json['manufactureYear'],
      engineType: json['engineType'],
      seatingCapacity: json['seatingCapacity'],
      batteryCapacity: json['batteryCapacity'],
      uniqueFeature: json['uniqueFeature'],
      images: List<String>.from(json['images']),
      availability: json['availability'],
      unavailabilityReason: json['unavailabilityReason'],
      currency: json['currency'],
      pricePerDay: json['pricePerDay'] != null
          ? double.parse(json['pricePerDay'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'logo': logo,
      'companyName': companyName,
      'model': model,
      'rentalDuration': rentalDuration,
      'licensePlate': licensePlate,
      'category': category,
      'manufactureYear': manufactureYear,
      'engineType': engineType,
      'seatingCapacity': seatingCapacity,
      'batteryCapacity': batteryCapacity,
      'uniqueFeature': uniqueFeature,
      'images': images,
      'availability': availability,
      'unavailabilityReason': unavailabilityReason,
      'currency': currency,
      'pricePerDay': pricePerDay,
    };
  }
}

class AvailableVehicleModels {
  final String companyName;
  final String model;

  AvailableVehicleModels({required this.companyName, required this.model});

  factory AvailableVehicleModels.fromJson(Map<String, dynamic> json) {
    return AvailableVehicleModels(
      companyName: json['companyName'],
      model: json['model'],
    );
  }
}
