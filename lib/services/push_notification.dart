import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/DB.dart';

class PushNotificationsService {
  PushNotificationsService._();

  factory PushNotificationsService() => _instance;

  static final PushNotificationsService _instance =
      PushNotificationsService._();

  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future<String> get fcmT => _fcm.getToken();
  bool _initialized = false;

  Future<void> init(BuildContext context) async {
    if (!_initialized) {
      // For iOS request permission first.
      _fcm.requestNotificationPermissions();
      _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          alert(message, context);
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          alert(message, context);
          // TODO optional
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          alert(message, context);
        },
      );

      // For testing purposes print the Firebase Messaging token
      //String token = await _fcm.getToken();
      //print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }

  void alert(Map<String, dynamic> message, BuildContext c) {
    showDialog(
      context: c,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(message['notification']['title']),
          subtitle: Text(message['notification']['body']),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Start'),
            onPressed: () {
              Task task =
                  new Task.setStatus(message['data']['task_id'], 'In Progress');
              DataBaseService().updateTaskData(task);
            },
          ),
          FlatButton(
              child: Text('Hide'),
              onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}
