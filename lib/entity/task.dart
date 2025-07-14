import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String? id;
  final String? createTime;
  final String? name;
  final String? description;
  final String? status;

  const Task({
    required this.id,
    required this.createTime,
    required this.name,
    required this.description,
    required this.status,
  });

  factory Task.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Task(
      id: data?['id'],
      createTime: data?['createTime'],
      name: data?['name'],
      description: data?['description'],
      status: data?['status'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (createTime != null) "createTime": createTime,
      if (name != null) "name": name,
      if (description != null) "description": description,
      if (status != null) "status": status,
    };
  }
}
