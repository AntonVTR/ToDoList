import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/models/task.dart';

class DataBaseService {
  final FirebaseUser user;

  //collection reference
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');
  final CollectionReference tasksCollection =
      Firestore.instance.collection('tasks');
  final CollectionReference utaskCollection =
      Firestore.instance.collection('user_task');

  DataBaseService({this.user});

  Future updateUserData() async {
    try {
      return usersCollection
          .document(user.email)
          .setData({"name": user.displayName, "email": user.email});
    } catch (e) {
      print("Error ${e.toString()}");
      return null;
    }
  }

  Future updateUserTask(Task t) async {
    try {
      return utaskCollection.document(t.assignedId).setData({"task": t.id});
    } catch (e) {
      print("Error ${e.toString()}");
      return null;
    }
  }

  Future removeUserTask(Task t) async {
    try {
      return utaskCollection.document(t.assignedId).delete();
    } catch (e) {
      print("Error ${e.toString()}");
      return null;
    }
  }

  List<String> _userEmailListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.documents.map((doc) {
        return (doc.documentID ?? '');
      }).toList();
    } catch (e) {
      print("Error ${e.toString()}");
    }
    return null;
  }

  Stream<List<String>> get getAllUserEmails {
    try {
      return usersCollection.snapshots().map(_userEmailListFromSnapshot);
    } catch (e) {
      print("Error getAllUserEmails ${e.toString()}");
    }
    return null;
  }

  Future getUserData(String id) {
    try {
      return usersCollection.document(id).get();
    } catch (e) {
      print("Error ${e.toString()}");
      return null;
    }
  }

  Future deleteUser(String id) {
    try {
      return usersCollection.document(id).delete();
    } catch (e) {
      print("Error ${e.toString()}");
      return null;
    }
  }

  Future addTaskData(Task task) async {
    try {
      return tasksCollection.add(task.toJson());
    } catch (e) {
      print("Error addTaskData ${e.toString()}");
      return null;
    }
  }

  Future updateTaskData(Task task) async {
    try {
      return tasksCollection.document(task.id).setData(task.toJson());
    } catch (e) {
      print("Error ${e.toString()}");
      return null;
    }
  }

  Future getAllOwnedTasks(FirebaseUser user) async {
    return null; //tasksCollection.where(field)
  }

  Future deleteTask(String id) {
    try {
      return tasksCollection.document(id).delete();
    } catch (e) {
      print("Error ${e.toString()}");
      return null;
    }
  }

  List<Task> _tasksListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Task.full(
          doc.documentID,
          doc.data['name'] ?? '',
          doc.data['description'] ?? '',
          doc.data['ownerId'] ?? '',
          doc.data['assignedId'] ?? '',
          doc.data['status'] ?? 'New',
          doc.data['startDate'] ?? '0',
          doc.data['finishDate'] ?? '0');
    }).toList();
  }

  //get task stream
  Stream<List<Task>> get tasksAll {
    try {
      return tasksCollection.snapshots().map(_tasksListFromSnapshot);
    } catch (e) {
      print("Error ${e.toString()}");
      return null;
    }
  }

  void updateDeviceToken(String token) {
    usersCollection
        .document(user.email)
        .collection('tokens')
        .document(token)
        .setData({'token': token});
  }
}
