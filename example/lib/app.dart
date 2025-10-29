import 'package:flutter/material.dart';
import 'package:map_camera/map_camera.dart';

class CameraMapApp extends StatelessWidget {
  const CameraMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return mainBody(context);
  }

  Widget mainBody(BuildContext context) => Scaffold(
        body: mainContent(context),
      );

  Widget mainContent(BuildContext context) => MapCameraLocation(
        cameraLensDirection: CameraLensDirection.back,
        onCapture: (file) {
          Navigator.of(context).pop(file);
        },
      );
}
