import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_camera/src/components/camera_preview/controller/camera_preview_controller.dart';

class CameraPreview extends StatelessWidget {
  const CameraPreview({super.key});

  CameraPreviewController get controller => Get.find();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
