import 'package:cabby/models/vehicle.dart';

final List<String> cities = [
  'Amsterdam',
  'Maastricht',
  'Rotterdam',
  'The Hague',
  'Discover Utrecht',
  'Amsterdam',
  'Maastricht',
  'Rotterdam',
  'The Hague',
  'Discover Utrecht'
];

List<String> vehicles = [
  'Toyota Camry',
  'Honda Civic',
  'Ford Mustang',
  'Chevrolet Corvette',
  'Dodge Charger',
  'Audi A4',
  'BMW 3 Series',
  'Mercedes-Benz C-Class',
];

Vehicle dummyVehicle = Vehicle(
  id: "uuid",
  logo: 'https://www.carlogos.org/car-logos/tesla-logo.png',
  companyName: 'Electric Motors Inc.',
  model: 'ElecDrive 3000',
  rentalDuration: '3 days minimum',
  licensePlate: 'XYZ-1234',
  category: 'Sedan',
  manufactureYear: '2020',
  engineType: 'Electric',
  seatingCapacity: '5',
  batteryCapacity: '5000mAh',
  uniqueFeature: 'Self-driving capability',
  images: [
    'https://storage.googleapis.com/cabby-bucket/images/images_ford_puma.jpeg',
    'https://storage.cloud.google.com/cabby-bucket/images/image-1696937825884.jpeg',
  ],
  availability: 'Available',
  unavailabilityReason: null,
  currency: 'EUR',
  pricePerDay: 59.99,
);
