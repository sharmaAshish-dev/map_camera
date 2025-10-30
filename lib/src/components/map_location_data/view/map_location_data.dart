import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:map_camera/src/map_camera_controller.dart';

class MapLocationData extends StatelessWidget {
  const MapLocationData({super.key, this.boxDecoration});

  final BoxDecoration? boxDecoration;

  MapCameraController get _controller => Get.find();

  @override
  Widget build(BuildContext context) {
    return mainBody;
  }

  Widget get mainBody => Container(
        decoration: boxDecoration ??
            BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black38,
            ),
        child: mainContent,
      );

  Widget get mainContent => Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _controller.locationService.locationName.value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _controller.locationService.subLocationName.value,
                style: const TextStyle(
                  fontSize: 8,
                  color: Colors.white,
                ),
              ),
              Text(
                'Lat: ${_controller.locationService.currentPosition.value.latitude}',
                style: const TextStyle(
                  fontSize: 8,
                  color: Colors.white,
                ),
              ),
              Text(
                'Long: ${_controller.locationService.currentPosition.value.longitude}',
                style: const TextStyle(
                  fontSize: 8,
                  color: Colors.white,
                ),
              ),
              Text(
                timestamp,
                style: const TextStyle(
                  fontSize: 8,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );

  String get timestamp {
    return DateFormat.yMd().add_jm().format(_controller.locationService.currentPosition.value.timestamp.toLocal());
  }
}
