import 'dart:io';

import 'package:geolocator/geolocator.dart';

class MapCameraResult {
  const MapCameraResult({
    required this.imageFile,
    required this.position,
  });

  final File imageFile;
  final Position position;
}
