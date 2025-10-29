import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:map_camera/src/map_camera_controller.dart';
import 'package:map_camera/src/service/location_service.dart';

class MapCameraBindings extends Bindings {
  MapCameraBindings({this.cameraLensDirection});

  final CameraLensDirection? cameraLensDirection;

  @override
  void dependencies() {
    Get.put(LocationService());

    Get.put(
      MapCameraController(
        locationService: Get.find(),
        cameraLensDirection: cameraLensDirection,
      ),
    );
  }
}
