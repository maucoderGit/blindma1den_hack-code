import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String? email;
  final double latitude;
  final double longitude;
  final String? message;
  final DateTime writeDate;
  final List storedMessages;

  factory Review.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Review(
      email: data?['email'] ?? "",
      latitude: data?['latitude'] ?? 0,
      longitude: data?['longitude']?? 0,
      writeDate: data?['write_date'] ?? DateTime.now(),
      message: data?['message'],
      storedMessages: data?['messages'] ?? [],
    );
  }

  Review({
    this.email,
    required this.latitude,
    required this.longitude,
    this.message,
    this.storedMessages = const [], required this.writeDate,
  });

  Map<String, dynamic> toFirestore() {
    return {
      "latitude": latitude,
      "longitude": longitude,
      "messages": storedMessages
    };
  }
}
