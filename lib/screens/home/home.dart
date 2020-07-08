import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task.dart';
import 'package:todo/screens/home/task_details.dart';
import 'package:todo/screens/home/task_list.dart';
import 'package:todo/services/DB.dart';
import 'package:todo/services/auth.dart';
import 'package:todo/shared/constants.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  void taskDetailPannel(Task task, String email, BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StreamProvider<List<String>>.value(
            value: DataBaseService().getAllUserEmails,
            child: Container(
              color: c[700],
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: TaskDetails(task),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return StreamProvider<List<Task>>.value(
      value: DataBaseService().tasksAll,
      child: Scaffold(
        backgroundColor: c[50],
        appBar: AppBar(
          title: Text('Main screen'),
          backgroundColor: c[400],
          elevation: 0,
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(Icons.person),
                label: Text('Sign out'))
          ],
        ),
        body: TaskList(user.email),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Task task = Task(user.email);
            taskDetailPannel(task, user.email, context);

            //tooltip
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
