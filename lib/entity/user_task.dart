import 'package:cloud_firestore/cloud_firestore.dart';

class UserTask {
  final DocumentReference? taskRef;

  const UserTask({required this.taskRef});

  factory UserTask.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return UserTask(taskRef: data?['taskRef']);
  }

  Map<String, dynamic> toFirestore() {
    return {if (taskRef != null) "taskRef": taskRef};
  }
}
