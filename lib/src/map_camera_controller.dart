import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:map_camera/src/service/location_service.dart';

class MapCameraController extends GetxController {
  MapCameraController({required this.locationService});

  final LocationService locationService;

  late CameraController cameraController;
  final isCameraInitialized = false.obs;
  final isCapturing = false
      .obs; // optional, to disable buttons during capture or show loader

  @override
  void onReady() {
    super.onReady();
    initializeCameraFeed();
  }

  /// Initialize the camera
  Future<void> initializeCameraFeed() async {
    isCameraInitialized.value = false;

    try {
      final cameras = await availableCameras();

      // Pick the back camera if available, else fallback
      final selectedCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      isCameraInitialized.value = false;
      Get.snackbar('Camera Error', e.toString());
    }
  }

  /// Capture an image and return the file
  Future<File?> onCaptureImage() async {
    if (!cameraController.value.isInitialized || isCapturing.value) return null;

    try {
      isCapturing.value = true;

      // Ensure camera is not recording or already capturing
      await cameraController.setFlashMode(FlashMode.off);

      final picture = await cameraController.takePicture();

      // Optionally move file to a persistent directory
      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/capture_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedFile = await File(picture.path).copy(imagePath);

      isCapturing.value = false;

      return savedFile;
    } catch (e) {
      isCapturing.value = false;
      Get.snackbar('Capture Error', e.toString());
      return null;
    }
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
