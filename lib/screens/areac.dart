import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apps/models/review.dart';
import 'package:flutter_apps/widgets/message_form.dart';
import 'package:flutter_apps/widgets/message_list.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserSelection { selectCoordinate, readingMessages, none }

class AreaCScreen extends StatefulWidget {
  const AreaCScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AreaCScreenState createState() => _AreaCScreenState();
}

class _AreaCScreenState extends State<AreaCScreen> {
  GoogleMapController? mapController;
  LatLng? _center;
  Position? _currentPosition;
  List records = [];
  LatLng? currentGeoPoint;

  static const double minExtent = 0;
  static const double maxExtent = 0.6;
  bool isExpanded = false;
  double initialExtent = 0.0;
  final DraggableScrollableController sheetController =
      DraggableScrollableController();

  final DraggableScrollableController formSheetController =
      DraggableScrollableController();

  UserSelection selection = UserSelection.none;

  Set<Marker> _markers = {};
  Set<Marker> _locationsSaved = {};

  @override
  void initState() {
    super.initState();
    _getUserLocation().whenComplete(() {
      getPlaces();
      handleMessage();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  getPlaces() async {
    final places = await FirebaseFirestore.instance
        .collection("zoneReviews")
        .withConverter(
            fromFirestore: Review.fromFirestore,
            toFirestore: (Review review, _) => review.toFirestore())
        .get();

    _locationsSaved = {};
    for (var docSnapshot in places.docs) {
      setState(() {
        _locationsSaved.add(Marker(
            markerId: MarkerId(
                "${docSnapshot.data().latitude}${docSnapshot.data().longitude}"),
            position: LatLng(
                docSnapshot.data().latitude, docSnapshot.data().longitude),
            // consumeTapEvents: true,
            onTap: () => {
              setState(() {
                selection = UserSelection.readingMessages;
                currentGeoPoint = LatLng(docSnapshot.data().latitude,
                    docSnapshot.data().longitude);

                records = docSnapshot.data().storedMessages;

                formSheetController.animateTo(0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceIn);
                sheetController.animateTo(0.2,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceIn);
              })
            }
          )
        );
      });
    }
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
// Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
// Request permission to get the user's location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }
// Get the current location of the user
    _currentPosition = await Geolocator.getCurrentPosition();
    setState(() {
      _center = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    });
  }

  handleMessage() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    print(fcmToken);

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

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
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
                    presentSound: true,
                    presentAlert: true,
                    presentBadge: true)),
            payload: 'Open from Local Notification');
      });
    }
  }

  void onSingleTap(LatLng latLng) {
    if (selection != UserSelection.none) {
      closeTab();
    } else {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId("${latLng.latitude}${latLng.longitude}"),
            position: latLng,
          ),
        );
        selection = UserSelection.selectCoordinate;
        currentGeoPoint = latLng;

        formSheetController.animateTo(0.45,
            duration: const Duration(milliseconds: 200),
            curve: Curves.bounceIn);
        sheetController.animateTo(0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.bounceIn);
      });
    }
  }

  void closeTab() {
    // Close the tab if it's open (adjust logic according to your needs)
    setState(() {
      _markers = {};
      selection =
          UserSelection.none; // or whatever logic to indicate closed state
      formSheetController.animateTo(0.0,
          duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
      sheetController.animateTo(0.0,
          duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SafeZone'),
          actions: [
            IconButton(onPressed: getPlaces, icon: const Icon(Icons.refresh))
          ],
        ),
        body: _center == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(fit: StackFit.expand, children: [
                SizedBox(
                  height: double.infinity,
                  child: GoogleMap(
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center!,
                      zoom: 15.0,
                    ),
                    onTap: (latLng) => onSingleTap(latLng),
                    markers: {
                      ..._markers,
                      ..._locationsSaved,
                    },
                  ),
                ),
                Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  child: FloatingActionButton(
                    onPressed: () async {

                      SharedPreferences prefs = await SharedPreferences.getInstance();

                    String? email = prefs.getString("user");
                    if (email == null) {
                      return;
                    }
                      Review coordinateReview = Review(
                          email: email,
                          message: "",
                          longitude: _center?.longitude ?? 0,
                          latitude: _center?.latitude ?? 0,
                          writeDate: DateTime.now(),
                          storedMessages: [
                            {
                              "message": "SOS",
                              "email": email,
                              "write_date": DateTime.now(),
                            }
                          ]);

                      FirebaseFirestore.instance
                          .collection('zoneReviews')
                          .add(coordinateReview.toFirestore());

                      FlutterLocalNotificationsPlugin fc =
                          FlutterLocalNotificationsPlugin();

                      fc.show(
                          0,
                          "Alerta SOS!!!",
                          "Alerta de emergencia",
                          const NotificationDetails(
                              android: AndroidNotificationDetails("app", "app",
                                  channelDescription: "prueba",
                                  importance: Importance.high,
                                  color: Colors.blue,
                                  playSound: true,
                                  icon: '@mipmap/ic_launcher'),
                              iOS: DarwinNotificationDetails(
                                  presentSound: true,
                                  presentAlert: true,
                                  presentBadge: true)),
                          payload: 'Open from Local Notification');
                    },
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.sos), //icono
                  ),
                ),
                messageList(minExtent, maxExtent, initialExtent, selection,
                    sheetController, records),
                registerMessageWidget(
                    minExtent,
                    maxExtent,
                    initialExtent,
                    selection,
                    currentGeoPoint?.latitude ?? 0,
                    currentGeoPoint?.longitude ?? 0,
                    formSheetController,
                    context),
              ]));
  }
}
