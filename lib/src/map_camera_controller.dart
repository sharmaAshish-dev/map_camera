import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:map_camera/src/service/location_service.dart';
import 'package:path_provider/path_provider.dart';

class MapCameraController extends GetxController {
  MapCameraController({required this.locationService, this.cameraLensDirection});

  final CameraLensDirection? cameraLensDirection;

  final mapDataKey = GlobalKey();
  final LocationService locationService;

  late CameraController cameraController;
  final isCameraInitialized = false.obs;
  final isCapturing = false.obs; // optional, to disable buttons during capture or show loader

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
        (camera) => camera.lensDirection == (cameraLensDirection ?? CameraLensDirection.front),
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
      throw Exception(e.toString());
    }
  }

  Future<File?> onCaptureImage() async {
    if (!cameraController.value.isInitialized || isCapturing.isTrue) return null;

    try {
      isCapturing.value = true;
      await cameraController.setFlashMode(FlashMode.off);

      // Capture from camera
      final picture = await cameraController.takePicture();
      final directory = await getTemporaryDirectory();
      final cameraImageFile = File(picture.path);

      // Capture widget (Render boundary)
      final RenderRepaintBoundary boundary = mapDataKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final ui.Image widgetImage = await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);

      // Convert both images to ui.Image
      final cameraBytes = await cameraImageFile.readAsBytes();
      final ui.Codec cameraCodec = await ui.instantiateImageCodec(cameraBytes);
      final ui.FrameInfo cameraFrame = await cameraCodec.getNextFrame();
      final ui.Image cameraUiImage = cameraFrame.image;

      // Now combine both on canvas
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);

      // Define size (same as camera)
      final Size size = Size(
        cameraUiImage.width.toDouble(),
        cameraUiImage.height.toDouble(),
      );

      // Draw camera first (background)
      final paint = ui.Paint();
      canvas.drawImage(cameraUiImage, Offset.zero, paint);

      // Calculate overlay position at bottom
      final double overlayHeight = widgetImage.height.toDouble();
      final double overlayWidth = widgetImage.width.toDouble();

      paint.isAntiAlias = true;

      final double offsetY = size.height - overlayHeight; // push to bottom

      canvas.drawImageRect(
        widgetImage,
        Rect.fromLTWH(0, 0, overlayWidth, overlayHeight),
        Rect.fromLTWH(0, offsetY, overlayWidth, overlayHeight), // draw at bottom
        paint,
      );

      final pictureResult = recorder.endRecording();
      final finalImage = await pictureResult.toImage(
        size.width.toInt(),
        size.height.toInt(),
      );

      // Convert to PNG bytes
      final byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // Save final composite image
      final imagePath = '${directory.path}/merged_${DateTime.now().millisecondsSinceEpoch}.png';
      final mergedFile = await File(imagePath).writeAsBytes(pngBytes);

      isCapturing.value = false;

      return mergedFile;
    } catch (e) {
      isCapturing.value = false;
      throw Exception(e.toString());
    }
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
