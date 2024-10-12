import 'package:flutter/material.dart';
import 'package:flutter_apps/widgets/map.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';


class AreaScreen extends StatefulWidget {
  const AreaScreen({super.key});

  
  @override
  State<AreaScreen> createState() => _AreaScreenState();
}

class _AreaScreenState extends State<AreaScreen> {
  final controller = MapController.withUserPosition(
    trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    )
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(controller: controller),
    );
  }
}