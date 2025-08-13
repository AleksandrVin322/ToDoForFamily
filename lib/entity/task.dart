import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String createTime;
  final String name;
  final String description;
  final String status;

  const Task({
    required this.id,
    required this.createTime,
    required this.name,
    required this.description,
    required this.status,
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      createTime: data['createTime'],
      name: data['name'],
      description: data['description'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "createTime": createTime,
      "name": name,
      "description": description,
      "status": status,
    };
  }
}
