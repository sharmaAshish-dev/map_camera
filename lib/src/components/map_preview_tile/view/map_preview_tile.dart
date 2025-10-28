import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_camera/src/map_camera_controller.dart';
import 'package:get/get.dart';

class MapPreviewTile extends StatelessWidget {
  const MapPreviewTile({super.key, this.tileSize});

  MapCameraController get _controller => Get.find();

  final Size? tileSize;

  @override
  Widget build(BuildContext context) {
    return mainBody;
  }

  Widget get mainBody => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: SizedBox(
      width: tileSize?.width ?? 100,
      height: tileSize?.height ?? 100,
      child: mainContent,
    ),
  );

  Widget get mainContent => Obx(
        () => FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(
          _controller.locationService.currentPosition.value.latitude,
          _controller.locationService.currentPosition.value.longitude,
        ),
        initialZoom: 13.0,
        onPositionChanged: (position, bool hasGesture) {},
      ),
      children: [
        TileLayer(
          tileProvider: NetworkTileProvider(
            headers: {
              'User-Agent': 'MyFlutterMapApp/1.0 (contact@example.com)',
              'Referer': 'https://myapp.example.com'
            },
          ),
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
          minZoom: 12,
        ),
        CurrentLocationLayer(
          alignPositionOnUpdate: AlignOnUpdate.always,
        ),
      ],
    ),
  );
}
