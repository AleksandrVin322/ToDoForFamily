import 'package:cloud_firestore/cloud_firestore.dart';

class UserBD {
  final String id;
  final String email;
  final String name;
  final DocumentReference? family;

  const UserBD({
    required this.id,
    required this.email,
    required this.name,
    this.family,
  });

  factory UserBD.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    final data = doc.data();
    return UserBD(
      id: doc.id,
      email: data?['email'],
      name: data?['name'],
      family: data?['family'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "family": family,
    };
  }

  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is UserBD && other.name == name && other.id == id;
  }
}
