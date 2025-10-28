import 'package:flutter/material.dart';
import 'package:map_camera/src/components/map_location_data/view/map_location_data.dart';
import 'package:map_camera/src/components/map_preview_tile/view/map_preview_tile.dart';
import 'package:map_camera/src/service/bindings.dart';

import 'components/camera_preview/view/map_camera_preview.dart';

class MapCameraLocation extends StatefulWidget {
  const MapCameraLocation({super.key, this.outerPadding});

  final EdgeInsets? outerPadding;

  @override
  State<MapCameraLocation> createState() => _MapCameraLocationState();
}

class _MapCameraLocationState extends State<MapCameraLocation> {
  @override
  void initState() {
    MapCameraBindings().dependencies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return mainBody;
  }

  Widget get mainBody => Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MapCameraPreview(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: mapData,
          ),
        ],
      );

  Widget get mapData => Padding(
        padding: widget.outerPadding ?? EdgeInsets.all(16),
        child: Row(
          children: [
            MapPreviewTile(),
            SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: MapLocationData(),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    MapCameraBindings().dispose();
    super.dispose();
  }
}
