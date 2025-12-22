import 'package:cloud_firestore/cloud_firestore.dart';

class UserTasks {
  final DocumentReference? taskRef;

  const UserTasks({required this.taskRef});

  factory UserTasks.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return UserTasks(taskRef: data?['taskRef']);
  }

  Map<String, dynamic> toFirestore() {
    return {if (taskRef != null) "taskRef": taskRef};
  }
}
