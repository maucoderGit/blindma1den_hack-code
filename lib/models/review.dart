import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String? email;
  final double latitude;
  final double longitude;
  final String? message;

  Review({
    this.email,
    required this.latitude,
    required this.longitude,
    this.message,
  });

  factory Review.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Review(
      email: data?['email'],
      latitude: data?['latitude'] ?? 0,
      longitude: data?['longitude']?? 0,
      message: data?['message'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (email != null) "email": email,
      "latitude": latitude,
      "longitude": longitude,
      if (message != null) "message": message,
    };
  }
}
