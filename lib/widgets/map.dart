import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapWidget extends StatelessWidget {
  final MapController controller;
  final Function(GeoPoint) geoPointTapped;

  const MapWidget({super.key, required this.controller, required this.geoPointTapped});

  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
      controller: controller,
      onGeoPointClicked: geoPointTapped,
      osmOption: OSMOption(
        staticPoints: [StaticPositionGeoPoint("id-1", const MarkerIcon(icon: Icon(Icons.warning_rounded),), [GeoPoint(latitude: 10.076287, longitude: -69.307409)])],
        showZoomController: true,
        zoomOption: const ZoomOption(initZoom: 16),
        enableRotationByGesture: false,
        userLocationMarker: UserLocationMaker(
          personMarker: const MarkerIcon(icon: Icon(Icons.location_on, size: 80, color: Colors.red)),
          directionArrowMarker: const MarkerIcon(icon: Icon(Icons.location_on, size: 80,color: Colors.red,))
        )
      ),
    );
  }
}
