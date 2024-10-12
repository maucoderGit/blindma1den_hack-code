import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apps/widgets/drawable_screen.dart';
import 'package:flutter_apps/widgets/map.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

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

  List records = [];

  bool isExpanded = false;
  double initialExtent = 0.0;
  BuildContext? draggableSheetContext;

  void geoPointTapMethod(GeoPoint geoPoint) {
    geoPoint.toMap();

    setState(() {
      selection = UserSelection.readingMessages;
      currentGeoPoint = geoPoint;

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
        DraggableScrollableSheet(
            controller: sheetController,
            minChildSize: minExtent,
            maxChildSize: maxExtent,
            initialChildSize: initialExtent,
            builder:
              (BuildContext context, ScrollController scrollController) =>
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: () {
                    switch (selection) {
                      case UserSelection.none:
                        return displayMessages(scrollController);
                      case UserSelection.selectCoordinate:
                        return displayRegisterMessage(scrollController);
                      case UserSelection.readingMessages:
                        return displayMessages(scrollController);
                    }
                  }(),
              )
        )
      ],
    ));
  }

  Widget displayMessages(ScrollController scrollController) {
    return ListView.builder(
      controller: scrollController,
      itemCount: records.length,
      itemBuilder: (context, index) {
        return const ListTile(
          leading: Text("TTTEESSTTT"),
          subtitle: Text("HEYYY"),
        );
      }
    );
  }

  Widget displayRegisterMessage(ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Form(child:
          Column(children: [
            Text("EJUEUEU")
          ],
        )
      ),
    );
  }

  @override
  void onSingleTap(GeoPoint position) {
    super.onSingleTap(position);

    setState(() {
      selection = UserSelection.selectCoordinate;
      currentGeoPoint = position;

      sheetController.animateTo(0.2,
          duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
    });
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    // TODO: implement mapIsReady
    return;
  }
}
