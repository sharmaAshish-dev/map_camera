import 'dart:io';

import 'package:geolocator/geolocator.dart';

class MapCameraResult {
  final File imageFile;
  final Position position;

  const MapCameraResult({
    required this.imageFile,
    required this.position,
  });
}