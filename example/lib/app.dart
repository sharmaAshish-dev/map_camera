import 'package:flutter/material.dart';
import 'package:map_camera/map_camera.dart';

class CameraMapApp extends StatelessWidget {
  const CameraMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return mainBody;
  }

  Widget get mainBody => Scaffold(
        body: mainContent,
      );

  Widget get mainContent => MapCameraLocation();
}
