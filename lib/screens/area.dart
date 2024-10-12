import 'package:flutter/material.dart';
import 'package:flutter_apps/widgets/map.dart';
import 'package:flutter_apps/widgets/message_form.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../widgets/message_list.dart';

enum UserSelection {
  selectCoordinate,
  readingMessages,
  none
}

class AreaScreen extends StatefulWidget {
  const AreaScreen({super.key});

  @override
  State<AreaScreen> createState() => _AreaScreenState();
}

class _AreaScreenState extends State<AreaScreen> with OSMMixinObserver {
  final controller = MapController.withUserPosition(
      trackUserLocation: const UserTrackingOption(
    enableTracking: true,
    unFollowUser: false,
  ));

  UserSelection selection = UserSelection.none;
  GeoPoint? currentGeoPoint;

  static const double minExtent = 0;
  static const double maxExtent = 0.6;

  final DraggableScrollableController sheetController =
      DraggableScrollableController();

  final DraggableScrollableController formSheetController =
  DraggableScrollableController();

  List records = [];

  bool isExpanded = false;
  double initialExtent = 0.0;
  BuildContext? draggableSheetContext;

  void geoPointTapMethod(GeoPoint geoPoint) {
    geoPoint.toMap();

    setState(() {
      selection = UserSelection.readingMessages;
      currentGeoPoint = geoPoint;

      formSheetController.animateTo(0,
          duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
      sheetController.animateTo(0.2,
          duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
    });
  }

  @override
  void initState() {
    super.initState();

    controller.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        MapWidget(controller: controller, geoPointTapped: geoPointTapMethod),
        messageList(minExtent, maxExtent, initialExtent, selection, sheetController, records),
        registerMessageWidget(minExtent, maxExtent, initialExtent, selection, formSheetController, context),
      ],
    ));
  }

  @override
  void onSingleTap(GeoPoint position) {
    super.onSingleTap(position);

    setState(() {
      selection = UserSelection.selectCoordinate;
      currentGeoPoint = position;

      formSheetController.animateTo(0.5,
          duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
      sheetController.animateTo(0.0,
          duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
    });
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    // TODO: implement mapIsReady
    return;
  }
}
