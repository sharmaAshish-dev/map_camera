import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_camera/src/components/map_location_data/view/map_location_data.dart';
import 'package:map_camera/src/components/map_preview_tile/view/map_preview_tile.dart';
import 'package:map_camera/src/models/map_camera_result.dart';
import 'package:map_camera/src/service/bindings.dart';

import 'components/camera_preview/view/map_camera_preview.dart';
import 'map_camera_controller.dart';

typedef MapCameraCaptureCallback = void Function(MapCameraResult result);

class MapCameraLocation extends StatefulWidget {
  const MapCameraLocation({super.key, this.outerPadding, required this.onCapture, this.cameraLensDirection});

  final EdgeInsets? outerPadding;
  final MapCameraCaptureCallback onCapture;
  final CameraLensDirection? cameraLensDirection;

  @override
  State<MapCameraLocation> createState() => _MapCameraLocationState();
}

class _MapCameraLocationState extends State<MapCameraLocation> {
  late MapCameraController controller;

  @override
  void initState() {
    MapCameraBindings(
      cameraLensDirection: widget.cameraLensDirection,
    ).dependencies();

    controller = Get.find();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return mainBody;
  }

  Widget get mainBody => Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MapCameraPreview(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                actionButton,
                mapData,
              ],
            ),
          ),
        ],
      );

  Widget get mapData => RepaintBoundary(
        key: controller.mapDataKey,
        child: Padding(
          padding: widget.outerPadding ?? const EdgeInsets.all(16),
          child: const Row(
            children: [
              MapPreviewTile(),
              SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: MapLocationData(),
              ),
            ],
          ),
        ),
      );

  Widget get actionButton => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () async {
              final captured = await controller.onCaptureImage();

              if (captured == null) {
                return;
              }

              widget.onCapture(
                MapCameraResult(
                  imageFile: captured,
                  position: controller.locationService.currentPosition.value,
                ),
              );
            },
            icon: Obx(
              () => controller.isCapturing.isFalse
                  ? const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    )
                  : const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    Get.delete<MapCameraController>(force: true);

    super.dispose();
  }
}
