import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task.dart';
import 'package:todo/screens/home/home.dart';
import 'package:todo/screens/home/task_tile.dart';
import 'package:todo/services/push_notification.dart';

class TaskList extends StatefulWidget {
  final String email;

  TaskList(this.email);

  @override
  _TaskListState createState() => _TaskListState(email);
}

class _TaskListState extends State<TaskList> {
  _TaskListState(String email);

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<List<Task>>(context);
    final user = Provider.of<FirebaseUser>(context);

    if (tasks != null) {
      return taskList(tasks, user);
    } else {
      return emptyTaskList();
    }
  }

  Widget emptyTaskList() {
    return Center(
      child: Text(
        "List of task is empty",
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget taskList(List<Task> tasks, FirebaseUser user) {
    PushNotificationsService().init(context);

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        if (tasks[index].ownerId == user.email) {
          tasks[index].isMy = true;
        }
        if (tasks[index].assignedId == user.email) {
          tasks[index].assignToMe = true;
        }

        return GestureDetector(
          child: TaskTile(tasks[index]),
          onTap: () {
            if (tasks[index].isMy && tasks[index].status != 'Complete') {
              Home().taskDetailPannel(tasks[index], user.email, context);
            }
          },
        );
      },
    );
  }
}
