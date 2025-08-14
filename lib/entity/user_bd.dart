import 'package:cloud_firestore/cloud_firestore.dart';

class UserBD {
  final String? id;
  final String? email;
  final String? name;

  const UserBD({required this.id, required this.email, required this.name});

  factory UserBD.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserBD(id: snapshot.id, email: data?['email'], name: data?['name']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (email != null) "email": email,
      if (name != null) "name": name,
    };
  }

  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is UserBD && other.name == name && other.id == id;
  }
}
