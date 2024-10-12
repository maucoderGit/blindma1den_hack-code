import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apps/widgets/map.dart';
import 'package:flutter_apps/widgets/message_form.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../widgets/message_list.dart';

enum UserSelection { selectCoordinate, readingMessages, none }

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
    handleMessage();
  }

  handleMessage() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    // print(fcmToken);

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
          FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      FlutterLocalNotificationsPlugin fc = FlutterLocalNotificationsPlugin();
      fc.show(
          0,
          message.notification?.title ?? "",
          message.notification?.body ?? "",
          const NotificationDetails(
              android: AndroidNotificationDetails("app", "app",
                  channelDescription: "prueba",
                  importance: Importance.high,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher'),
              iOS: DarwinNotificationDetails(
                  presentSound: true, presentAlert: true, presentBadge: true)),
          payload: 'Open from Local Notification');
    });
    }
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
        messageList(minExtent, maxExtent, initialExtent, selection,
            sheetController, records),
        registerMessageWidget(minExtent, maxExtent, initialExtent, selection,
            formSheetController, context),
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
