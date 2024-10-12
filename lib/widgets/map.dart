import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapWidget extends StatelessWidget {
  final MapController controller;

  const MapWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
      controller: controller,
      osmOption: OSMOption(
        showZoomController: true,
        zoomOption: const ZoomOption(initZoom: 15),
        enableRotationByGesture: false,
        userLocationMarker: UserLocationMaker(
          personMarker: const MarkerIcon(icon: Icon(Icons.location_on, size: 120,)),
          directionArrowMarker: const MarkerIcon(icon: Icon(Icons.arrow_downward_rounded))
        )
      ),
    );
  }
}
