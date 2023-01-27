import 'dart:io';

class BirdModel {
  final String? birdName;
  final double latitude;
  final double longitude;
  final String? birdDescription;
  final File image;

  BirdModel({
    required this.image,
    required this.longitude,
    required this.latitude,
    required this.birdDescription,
    required this.birdName,
  });
}
