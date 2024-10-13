import 'package:cloud_firestore/cloud_firestore.dart';

class UserDB {
  final String email;
  final String name;
  final String? phone;
  final String? photo;

  factory UserDB.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserDB(
      email: data?['email'],
      name: data?['name'],
      phone: data?['phone']?? "",
      photo: data?['photo']?? "",
    );
  }

  UserDB({
    required this.email,
    required this.name,
    this.phone,
    this.photo,
  });

  Map<String, dynamic> toFirestore() {
    return {
      "email": email,
      "name": name,
      "phone": phone,
      "photo": photo
    };
  }
}
