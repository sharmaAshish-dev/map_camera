import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_camera/src/map_camera_controller.dart';

class MapCameraPreview extends StatelessWidget {
  const MapCameraPreview({super.key});

  MapCameraController get _controller => Get.find();

  @override
  Widget build(BuildContext context) {
    return mainBody(context);
  }

  Widget mainBody(BuildContext context) => Obx(
        () => _controller.isCameraInitialized.isTrue
            ? mainContent(context)
            : const Center(child: CircularProgressIndicator()),
      );

  Widget mainContent(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    final scale = 1 / (_controller.cameraController.value.aspectRatio * mediaSize.aspectRatio);
    return ClipRect(
      clipper: _MediaSizeClipper(mediaSize),
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.topCenter,
        child: CameraPreview(_controller.cameraController),
      ),
    );
  }
}

class _MediaSizeClipper extends CustomClipper<Rect> {
  const _MediaSizeClipper(this.mediaSize);

  final Size mediaSize;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, mediaSize.width, mediaSize.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
