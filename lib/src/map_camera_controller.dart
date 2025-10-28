import 'dart:async';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:map_camera/src/service/location_service.dart';

class MapCameraController extends GetxController {
  MapCameraController({required this.locationService});

  final LocationService locationService;

  late CameraController cameraController;

  var isCameraInitialized = false.obs;

  @override
  void onReady() {
    initializeCameraFeed;
    super.onReady();
  }

  Future<void> get initializeCameraFeed async {
    isCameraInitialized.value = false;

    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.elementAt(1);

      cameraController = CameraController(firstCamera, ResolutionPreset.medium, enableAudio: false);

      await cameraController.initialize();

      isCameraInitialized.value = true;
    } catch (e) {
      isCameraInitialized.value = false;
      throw Exception(e);
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
