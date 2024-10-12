import 'package:flutter/material.dart';
import 'package:flutter_apps/widgets/custom_text_input.dart';
import 'package:flutter_apps/widgets/map.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../constants/border_radius.dart';

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
      child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                          )),
                      Card.filled(
                        elevation: 0,
                        color: const Color.fromRGBO(0, 5, 27, 1.0),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Colors.black
                          ),
                          borderRadius: cardRadius(),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Text("", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
                        ),
                      )
                    ]
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width / 1.15, child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color.fromRGBO(191, 191, 191, 1.0)
                        ),
                        borderRadius: cardRadius(),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                        child: Text(""),
                      )
                  )),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width / 1.15, child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: Color.fromRGBO(191, 191, 191, 1.0)
                      ),
                      borderRadius: cardRadius(),
                    ),
                    child: CustomTextInput(
                      hintText: 'sale_order_notification.default_message', userTyped: (value) {
                    }, obscure: false, defaultValue: "",
                    ),
                  )),
                ],
              ),
              Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.transparent,
                            disabledForegroundColor: Colors.grey
                        ),
                        onPressed: () async {

                          Navigator.pop(context, true);
                        },
                        child: const Text("sale_order_notification.send_message"),
                      ),
                    ],
                ),
            ],
          )),
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
