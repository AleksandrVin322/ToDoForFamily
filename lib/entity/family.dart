import 'package:cloud_firestore/cloud_firestore.dart';

class Family {
  final String id;
  final String name;

  const Family({
    required this.id,
    required this.name,
  });

  factory Family.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    final data = doc.data() as Map<String, dynamic>;

    return Family(
      id: doc.id,
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
    };
  }
}
